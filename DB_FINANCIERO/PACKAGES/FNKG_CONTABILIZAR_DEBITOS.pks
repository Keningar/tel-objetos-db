CREATE EDITIONABLE PACKAGE               FNKG_CONTABILIZAR_DEBITOS
AS 

--
/**
* Documentacion para el PKG FNKG_CONTABILIZAR_DEBITOS
* El PKG FNKG_CONTABILIZAR_DEBITOS contendra las variables que sean necesarias a usar en los PKG de consultas o transacciones
* separando procedimientos y funciones de las declaraciones de variables.
* Genera los asientos contables para los debitos creados en la aplicacion Telcos.
* @author Andres Montero <amontero@telconet.ec>
* @version 1.0 16-04-2016
*/
--

type tb_debitos_oficinas is table of FNKG_TRANSACTION_CONTABILIZAR.TypeDebitosOficina index by pls_integer; 
type tb_pagos_debitos is table of FNKG_TRANSACTION_CONTABILIZAR.TypePagosDebito index by pls_integer;

  /*
  * Documentaci�n para FUNCION 'PROCESAR_DEBITOS'.
  * PROCEDIMIENTO QUE CREA ASIENTOS CONTABLES PARA LOS DEBITOS
  * PARAMETROS:
  * @Param in  varchar2  v_no_cia (id de la empresa)
  * @Param in  number    v_debito_gen_histo_id (id del debito general historial)
  * @Param in  varchar2  v_tipo (tipo de proceso)
  * @Param out Pv_Mensaje   Pv_Mensaje (mensaje que retorna al finalizar proceso o cuando se produza un error)
  * 
  * @version 1.0 Version Inicial
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 24-08-2017 - Se agrega al query principal la validaci�n para que no retorne los pagos que ya hayan sido migrados al NAF.
  *                           Se agregan las funciones implementadas en NAF 'NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKMM' para insertar en la
  *                           tabla 'MIGRA_ARCKMM'
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.2 12-09-2017 - Se renombra la variable la variable 'msg_ret' a 'Pv_Mensaje' para que retorne el mensaje adecuado.
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.3 13-09-2017 - Se modifica el 'NO_DOCU' para que sea diferente en cada proceso de debito migrado.
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.4 05-10-2017 - Se agrega segmentaci�n en dos plantillas contables para PAGOS y ANTICIPOS cuando se procesan los debitos masivos.
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.5 05-02-2018 - Se modifica para considerar cuenta bancaria registrada en tabla debito general
  */
  PROCEDURE PROCESAR_DEBITOS(
      v_no_cia              IN VARCHAR2,
      v_debito_gen_histo_id IN VARCHAR2,
      v_tipo                IN VARCHAR2 ,
      Pv_Mensaje            OUT VARCHAR2);

PROCEDURE CREA_ASIENTO_DEBITO_DEBITOS(
    
    pt_plantilla_contable_cab in FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableCab,
    p_migra_arckmm MIGRA_ARCKMM%ROWTYPE,
    lr_datos_debito in FNKG_TRANSACTION_CONTABILIZAR.TypeDatosDebito,
    p_no_cia varchar2,
    msg_ret out varchar2,
    p_cuenta_contable in varchar2 default null
    ,Pn_IdMigracion18 naf47_tnet.migra_arckmm.id_migracion%type default null
    );
    
PROCEDURE CREA_ASIENTO_CREDITO_DEBITOS(

    pt_plantilla_contable_cab in FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableCab,
    p_migra_arckmm MIGRA_ARCKMM%ROWTYPE,    
    lr_datos_debito in FNKG_TRANSACTION_CONTABILIZAR.TypeDatosDebito,
    lr_debitos_oficina   tb_debitos_oficinas, 
    p_no_cia varchar2,
    msg_ret out varchar2,
    Pn_IdDebitoGeneral  NUMBER DEFAULT NULL
,Pn_IdMigracion18 naf47_tnet.migra_arckmm.id_migracion%type default null
); 
PROCEDURE MARCA_CONTABILIZADO_PAGO(lr_pagos_debito IN tb_pagos_debitos);    

FUNCTION GET_PORCENTAJE_RETENCIONES(p_empresa_cod varchar2,p_valor1 varchar2) RETURN number;

FUNCTION GET_CUENTA_CONTABLE_POR_DESC(p_descripcion_cuenta VARCHAR2, p_tipo_cuenta VARCHAR2, p_empresa_cod VARCHAR2) RETURN VARCHAR2;

/*
* Documentaci�n para FUNCION 'F_GET_CUENTA_CONTABLE_POR_TIPO'.
* FUNCION QUE OBTIENE LA CUENTA CONTABLE POR TIPO CUENTA
* @author Luis Lindao <llindao@telconet.ec>
* @version 1.0
* @since 07/02/2018
*
* @Param in varchar2 Pv_NombreCampoRef (descripcion cuenta contable)
* @Param in number   Pv_NombreCampoRef (id tipo cuenta contable)
* @Param in varchar2 Pv_NombreTipoCtaCble (Descripci�n de tipo cuenta contable)
* @Param in varchar2 Pv_NoCia (empresa)
*@Return FNKG_TRANSACTION_CONTABILIZAR.TypeCuentaContable retorna datos de la cuenta contable
*/
  FUNCTION F_GET_CUENTA_CONTABLE_POR_TIPO( Pv_ValorCampoRef     NUMBER,
                                           Pv_NombreCampoRef    VARCHAR2, 
                                           Pv_NombreTipoCtaCble VARCHAR2, 
                                           Pv_NoCia             VARCHAR2
                                         ) RETURN FNKG_TRANSACTION_CONTABILIZAR.TypeCuentaContable;


/*
* Documentaci�n para FUNCION 'P_DEBITOS_MASIVOS_MD'.
* Procedimiento que migra masivamente los debitos del d�a
* @author Luis Lindao <llindao@telconet.ec>
* @version 1.0
* @since 07/02/2018
*
* @Param in varchar2 Pv_NoCia (empresa)
* @Param in varchar2 Pv_FechaProceso (fecha de proceso)
* @Param in out varchar2 Pv_MensajeError (Mensaje retorna errores)
*/
  PROCEDURE P_DEBITOS_MASIVOS_MD  (Pv_NoCia        IN VARCHAR2,
                                   Pv_FechaProceso IN VARCHAR2,
                                   Pv_MensajeError IN OUT VARCHAR2 );


END FNKG_CONTABILIZAR_DEBITOS;
/

CREATE EDITIONABLE PACKAGE BODY               FNKG_CONTABILIZAR_DEBITOS
AS

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
 
  --
  PROCEDURE PROCESAR_DEBITOS(
    v_no_cia              IN VARCHAR2,
    v_debito_gen_histo_id IN VARCHAR2,
    v_tipo                IN VARCHAR2 ,
    Pv_Mensaje            OUT VARCHAR2)
  IS
    --
    Lv_MensajeError    VARCHAR2(4000);
    lr_debito          FNKG_TRANSACTION_CONTABILIZAR.TypeDebito;
    lr_datos_debito    FNKG_TRANSACTION_CONTABILIZAR.TypeDatosDebito;      
    lr_debitos_oficina tb_debitos_oficinas;  
    lr_pagos_debito    tb_pagos_debitos;
    l_migra_arckmm     MIGRA_ARCKMM%ROWTYPE;
    l_migra_arckml     MIGRA_ARCKML%ROWTYPE;  
    
    l_MsnError varchar2(500);

    ex_insert_arckmm EXCEPTION;
    PRAGMA EXCEPTION_INIT( ex_insert_arckmm, -20003 );
    
    ex_insert_arckml EXCEPTION;
    PRAGMA EXCEPTION_INIT( ex_insert_arckml, -20004 );     

    
    ex_no_hay_datos EXCEPTION;
    PRAGMA EXCEPTION_INIT( ex_no_hay_datos, -20005 ); 


    ex_no_hay_plantilla_cab EXCEPTION;
    PRAGMA EXCEPTION_INIT( ex_no_hay_plantilla_cab, -20006 ); 
    --cursor detalles de debitos
    CURSOR C_GetDebitos( Cn_DebitoGeneralHisto DB_FINANCIERO.INFO_PAGO_CAB.DEBITO_GENERAL_HISTORIAL_ID%TYPE,
                         Cv_NombrePaqueteSQL DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.NOMBRE_PAQUETE_SQL%TYPE,
                         Cv_EmpresaCod DB_COMERCIAL.INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE,
                         Cv_EstadoActivo DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
                         Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                         Cv_LabelEstadoPago DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
                         Cv_CodTipoDocumento DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE )
    IS
      --
      SELECT ATDF.CODIGO_TIPO_DOCUMENTO,
        IPC.VALOR_TOTAL,
        IPC.OFICINA_ID,
        IOG.NOMBRE_OFICINA,
        ATC.DESCRIPCION_CUENTA ,
        IPD.ID_PAGO_DET,
        IPD.PAGO_ID,
        IPC.ESTADO_PAGO,
        IPC.TIPO_DOCUMENTO_ID,
        IPC.USR_CREACION
      FROM DB_FINANCIERO.INFO_PAGO_CAB IPC
      JOIN DB_FINANCIERO.INFO_PAGO_DET IPD
      ON IPC.ID_PAGO = IPD.PAGO_ID
      JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO IOG
      ON IPC.OFICINA_ID = IOG.ID_OFICINA
      JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
      ON ATDF.ID_TIPO_DOCUMENTO = IPC.TIPO_DOCUMENTO_ID
      JOIN DB_GENERAL.ADMI_BANCO_TIPO_CUENTA ABTC
      ON ABTC.ID_BANCO_TIPO_CUENTA=IPD.BANCO_TIPO_CUENTA_ID
      JOIN DB_GENERAL.ADMI_TIPO_CUENTA ATC
      ON ABTC.TIPO_CUENTA_ID                = ATC.ID_TIPO_CUENTA
      LEFT JOIN NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO MDA
      ON MDA.DOCUMENTO_ORIGEN_ID  = IPD.ID_PAGO_DET
      WHERE IPC.DEBITO_GENERAL_HISTORIAL_ID = Cn_DebitoGeneralHisto
      AND ATDF.CODIGO_TIPO_DOCUMENTO = Cv_CodTipoDocumento
      AND (MDA.MIGRACION_ID         IS NULL
      OR MDA.TIPO_DOC_MIGRACION NOT IN
        (SELECT COD_DIARIO
        FROM DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB
        WHERE NOMBRE_PAQUETE_SQL = Cv_NombrePaqueteSQL
        AND EMPRESA_COD          = Cv_EmpresaCod
        AND ESTADO               = Cv_EstadoActivo
        GROUP BY COD_DIARIO
        ))
      AND IPC.ESTADO_PAGO                  IN
        (SELECT APD.VALOR2
        FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
        JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC
        ON APC.ID_PARAMETRO        = APD.PARAMETRO_ID
        WHERE APC.NOMBRE_PARAMETRO = Cv_NombreParametro
        AND APC.ESTADO             = Cv_EstadoActivo
        AND APD.ESTADO             = Cv_EstadoActivo
        AND APD.DESCRIPCION        = Cv_NombrePaqueteSQL
        AND APD.VALOR1             = Cv_LabelEstadoPago
        AND APD.EMPRESA_COD        = Cv_EmpresaCod
        );
      --
    --
    --cursor datos para asientos debito
    CURSOR c_datos_debito 
    IS
      SELECT dgh.DEBITO_GENERAL_ID,
        dgh.ID_DEBITO_GENERAL_HISTORIAL,
        dgh.NUMERO_DOCUMENTO,
        dgh.FE_DOCUMENTO,
        dgh.PORCENTAJE_COMISION_BCO,
        dgh.CONTIENE_RETENCION_FTE,
        dgh.CONTIENE_RETENCION_IVA,
        gdcab.NOMBRE_GRUPO,
        dgh.FE_CREACION,
        dgh.USR_CREACION,
        NVL(DGEN.CUENTA_CONTABLE_ID, dgh.CUENTA_CONTABLE_ID) CUENTA_CONTABLE_ID,
        '',
        0,0,0,
        dgh.VALOR_RETENCION_FUENTE,
        dgh.VALOR_COMISION_BCO,
        dgh.VALOR_RETENCION_IVA,
        dgh.VALOR_NETO,
        0,
        dgen.OFICINA_ID
      FROM DB_FINANCIERO.INFO_DEBITO_GENERAL_HISTORIAL dgh
      JOIN DB_FINANCIERO.INFO_DEBITO_GENERAL dgen
      ON dgh.debito_general_id=dgen.id_debito_general
      JOIN DB_FINANCIERO.ADMI_GRUPO_ARCHIVO_DEBITO_CAB gdcab
      ON dgen.grupo_debito_id               = gdcab.id_grupo_debito
      WHERE dgh.ID_DEBITO_GENERAL_HISTORIAL = v_debito_gen_histo_id;


    l_descripcion         varchar2(40) :='';
    l_no_cta_destino      varchar2(16) :='';
    l_no_cta_cble_destino varchar2(16) :='';
    l_total               number := 0;
    l_total_valor_pago    number := 0;
    l_no_fisico           varchar2(16);
    l_serie_fisico        varchar2(16); 
    l_numero_documento    varchar2(100);
    l_valor_comision      number := 0;
    l_valor_neto          number := 0;
    l_porc_retencion_fte  number := 0;
    l_porc_retencion_iva  number := 0;    
    l_valor_cal_base_imp  number := 0;
    l_valor_retencion_fte number := 0;
    l_valor_retencion_iva number := 0;
    l_valor_pago          number := 0; 
    ind_oficina           number; 
    l_valor_base_imponib  number; 
    l_prefijo             varchar2(5);   
    indice                number;
    r_plantilla_contable_cab FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableCab;
    r_cuenta_contable FNKG_TRANSACTION_CONTABILIZAR.TypeCuentaContable;
    --
    Lv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE                := 'VALIDACIONES_PROCESOS_CONTABLES';
    Lv_NombrePaqueteSQL DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.NOMBRE_PAQUETE_SQL%TYPE := 'FNKG_CONTABILIZAR_DEBITOS';
    Lv_EstadoActivo DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE                             := 'Activo';
    Lv_LabelEstadoPago DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE                          := 'ESTADO_PAGO';
    Lv_LabelCodTipoDocumento DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE                    := 'CODIGO_TIPO_DOCUMENTO';
    --
    Le_MigraDocumentoAsociado EXCEPTION;
    PRAGMA EXCEPTION_INIT( Le_MigraDocumentoAsociado, -20010 );
    --
    Lr_MigraDocumentoAsociado NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO%ROWTYPE;
    --
    --
    --CURSOR C_GetParametrosDet obtiene los detalles de los parametros segun los par�metros enviados por el usuario
    --COSTO QUERY: 9 
    CURSOR C_GetDetalleParametros( Cv_NombreParameteroCab DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                   Cv_EstadoParametroCab  DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                                   Cv_EstadoParametroDet  DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                                   Cv_Descripcion         DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                                   Cv_Valor1              DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
                                   Cv_EmpresaCod          DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE )
    IS
      --
      SELECT APD.ID_PARAMETRO_DET, APD.PARAMETRO_ID, APD.VALOR1, APD.VALOR2, APD.VALOR3, APD.VALOR4, APD.VALOR5
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC, 
           DB_GENERAL.ADMI_PARAMETRO_DET APD 
      WHERE APC.ID_PARAMETRO    = APD.PARAMETRO_ID 
      AND APC.ESTADO            = NVL(Cv_EstadoParametroCab, APC.ESTADO ) 
      AND APD.ESTADO            = NVL(Cv_EstadoParametroDet, APD.ESTADO ) 
      AND APC.NOMBRE_PARAMETRO  = NVL(Cv_NombreParameteroCab, APC.NOMBRE_PARAMETRO ) 
      AND APD.DESCRIPCION       = NVL(Cv_Descripcion, APD.DESCRIPCION ) 
      AND APD.VALOR1            = NVL(Cv_Valor1, APD.VALOR1 ) 
      AND APD.EMPRESA_COD       = NVL(Cv_EmpresaCod, APD.EMPRESA_COD );
      --
    --
    Lr_GetDetalleParametros C_GetDetalleParametros%ROWTYPE;
    Ln_TipoDocumentoId NUMBER;
    --
    Ln_IdMigracion33 NUMBER;
    Ln_IdMigracion18 NUMBER;
    
    Lv_EmpresaOrigen db_general.admi_parametro_det.valor2%type;
    Lv_EmpresaDestino db_general.admi_parametro_det.valor2%type;
    Lv_BanderaReplicar db_general.admi_parametro_det.valor2%type;
    --
  BEGIN
    
    Lv_EmpresaOrigen := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'EMPRESA_ORIGEN');
    Lv_EmpresaDestino := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'EMPRESA_DESTINO');
    Lv_BanderaReplicar := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'APLICA_REPLICA_MIGRACION');

    --SE REGISTRAN LOS SIGUIENTES PARAMETROS EN LA TABLA INFO_ERROR dnatha 29/10/2019
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'LOG DE EJECUCION DE PAGOS',
                                          'Ejecucion del proceso FNKG_CONTABILIZAR_DEBITOS.PROCESAR_DEBITOS con los sgtes parametros... Codigo de empresa: ' || v_no_cia || ' debitoGeneralHistorialId: ' || v_debito_gen_histo_id || ' tipo: ' || v_tipo,
                                          'telcos',
                                          SYSDATE,    
                                          '172.0.0.1');

    DBMS_OUTPUT.ENABLE(null);
    --
    --obtenemos prefijo de empresa   
    l_prefijo := FNKG_CONTABILIZAR_PAGO_MANUAL.OBTIENE_PREFIJO_EMPRESA(v_no_cia);

    l_porc_retencion_fte := GET_PORCENTAJE_RETENCIONES(v_no_cia,'PORCENTAJE_RETENCION_FUENTE_DEBITOS');
    l_porc_retencion_iva := GET_PORCENTAJE_RETENCIONES(v_no_cia,'PORCENTAJE_RETENCION_IVA_DEBITOS');
    l_valor_cal_base_imp := GET_PORCENTAJE_RETENCIONES(v_no_cia,'VALOR_BASE_IMPONIBLE');
    
    --RECORRE LOS DATOS PARA EL DEBITO GENERAL
    OPEN c_datos_debito;
    --
    FETCH c_datos_debito INTO lr_datos_debito;
    --
    --
    IF C_GetDetalleParametros%ISOPEN THEN
      CLOSE C_GetDetalleParametros;
    END IF;
    --
    OPEN C_GetDetalleParametros( Lv_NombreParametro,
                                 Lv_EstadoActivo,
                                 Lv_EstadoActivo,
                                 Lv_NombrePaqueteSQL,
                                 Lv_LabelCodTipoDocumento,
                                 v_no_cia );
    --
    LOOP
      --
      FETCH C_GetDetalleParametros INTO Lr_GetDetalleParametros;
      EXIT WHEN C_GetDetalleParametros%NOTFOUND;
      --
      IF Lr_GetDetalleParametros.VALOR2 IS NOT NULL THEN
        --
        --OBTIENE DATOS DE LA CABECERA DE LA PLANTILLA
        r_plantilla_contable_cab := NULL;
        r_plantilla_contable_cab := DB_FINANCIERO.FNKG_CONTABILIZAR_PAGO_MANUAL.GET_PLANTILLA_CONTABLE_CAB_COD( v_no_cia, 
                                                                                                                'DEB' ,
                                                                                                                Lr_GetDetalleParametros.VALOR2,
                                                                                                                'MASIVO' );
        DBMS_OUTPUT.PUT_LINE('idcab:'||r_plantilla_contable_cab.ID_PLANTILLA_CONTABLE_CAB || ' cab:' ||r_plantilla_contable_cab.TABLA_CABECERA);
        --
        if nvl(Lv_BanderaReplicar,'N') = 'S' AND v_no_cia = Lv_EmpresaOrigen then
           l_migra_arckmm .ID_MIGRACION := NAF47_TNET.TRANSA_ID.MIGRA_CK (Lv_EmpresaOrigen);
           Ln_IdMigracion33 := l_migra_arckmm.ID_MIGRACION;
           Ln_IdMigracion18 := NAF47_TNET.TRANSA_ID.MIGRA_CK (Lv_EmpresaDestino);
        else
          l_migra_arckmm.ID_MIGRACION := NAF47_TNET.TRANSA_ID.MIGRA_CK (v_no_cia);
        end if;
        --
        lr_debitos_oficina.DELETE;
        --
        Ln_TipoDocumentoId    := 0;
        l_numero_documento    := lr_datos_debito.NUMERO_DOCUMENTO;
        l_valor_comision      := 0;
        l_valor_neto          := 0;
        l_valor_retencion_fte := 0;
        l_valor_retencion_iva := 0; 
        l_valor_pago          := 0; 
        l_valor_base_imponib  := 0;
        --
        --RECORRE LOS DATOS DEL DETALLE DE PAGO
        OPEN C_GetDebitos( v_debito_gen_histo_id, 
                           Lv_NombrePaqueteSQL,
                           v_no_cia,
                           Lv_EstadoActivo,
                           Lv_NombreParametro,
                           Lv_LabelEstadoPago,
                           Lr_GetDetalleParametros.VALOR2 );
        --
        indice:=0;
        --
        lr_datos_debito.TOTAL_PAGOS     := 0;
        lr_datos_debito.TOTAL_ANTICIPOS := 0;
        lr_datos_debito.TOTAL_NETO      := 0;
        LOOP
        FETCH C_GetDebitos INTO lr_debito;
            --
            EXIT WHEN C_GetDebitos%NOTFOUND;
            --
            lr_debitos_oficina(lr_debito.OFICINA_ID).ID_OFICINA     := lr_debito.OFICINA_ID;
            lr_debitos_oficina(lr_debito.OFICINA_ID).NOMBRE_OFICINA := lr_debito.NOMBRE_OFICINA;
            --
            dbms_output.put_line('tipo pago:'||lr_debito.CODIGO_TIPO_DOCUMENTO);
            dbms_output.put_line('valor pago:'||lr_debito.VALOR_PAGO);
            --
            --GUARDA PAGO EN ARREGLO
            lr_pagos_debito(indice).ID_PAGO_DET:=lr_debito.ID_PAGO_DET;
            lr_pagos_debito(indice).ID_PAGO:=lr_debito.ID_PAGO;
            lr_pagos_debito(indice).ESTADO_PAGO:=lr_debito.ESTADO_PAGO;
            --
            --
            Lr_MigraDocumentoAsociado                     := NULL;
            Lr_MigraDocumentoAsociado.DOCUMENTO_ORIGEN_ID := lr_debito.ID_PAGO_DET;
            Lr_MigraDocumentoAsociado.TIPO_DOC_MIGRACION  := r_plantilla_contable_cab.COD_DIARIO;
            Lr_MigraDocumentoAsociado.NO_CIA              := v_no_cia;
            Lr_MigraDocumentoAsociado.FORMA_PAGO_ID       := r_plantilla_contable_cab.ID_FORMA_PAGO;
            Lr_MigraDocumentoAsociado.TIPO_DOCUMENTO_ID   := lr_debito.TIPO_DOCUMENTO_ID;
            Lr_MigraDocumentoAsociado.ESTADO              := 'M';
            Lr_MigraDocumentoAsociado.USR_CREACION        := lr_debito.USR_CREACION;
            Lr_MigraDocumentoAsociado.FE_CREACION         := SYSDATE;
            Lr_MigraDocumentoAsociado.MIGRACION_ID        := l_migra_arckmm.ID_MIGRACION;
            Lr_MigraDocumentoAsociado.TIPO_MIGRACION      := 'CK';
            --
            Ln_TipoDocumentoId := lr_debito.TIPO_DOCUMENTO_ID;
            --
            --
            IF v_tipo='AUTOMATICO' THEN
            
                l_valor_base_imponib  := ROUND(lr_debito.VALOR_PAGO / l_valor_cal_base_imp, 2 );
                
                --CALCULA COMISION BANCARIA
                ------------------------
                l_valor_comision := ROUND(lr_debito.VALOR_PAGO * (lr_datos_debito.PORCENTAJE_COMISION_BCO/100),2);
                l_valor_neto     := ROUND(lr_debito.VALOR_PAGO - l_valor_comision,2);
                

                --CALCULA RETENCION A LA FUENTE
                -------------------------
                IF lr_datos_debito.CONTIENE_RET_FTE='S' THEN
                    IF TRIM(UPPER(lr_debito.DESCRIPCION_CUENTA))='TARJETA DINERS' THEN
                    
                        l_valor_retencion_fte:=ROUND(l_valor_base_imponib * (l_porc_retencion_fte/100),2);                    
                       
                    ELSE
                        l_valor_retencion_fte:=ROUND((l_valor_base_imponib - l_valor_comision) * (l_porc_retencion_fte/100),2);   
                    END IF; 
                    l_valor_neto := ROUND(l_valor_neto - l_valor_retencion_fte,2);
                END IF;
                
                            
                --CALCULA RETENCION IVA
                -----------------------
                IF lr_datos_debito.CONTIENE_RET_IVA='S' THEN
                    l_valor_retencion_iva := ROUND(((lr_debito.VALOR_PAGO) * (l_porc_retencion_iva/100)),2);
                    l_valor_neto          := ROUND(l_valor_neto - l_valor_retencion_iva,2);                
                END IF;
                --
                --
                lr_datos_debito.TOTAL_BASEIMP       := lr_datos_debito.TOTAL_BASEIMP + l_valor_base_imponib;
                lr_datos_debito.TOTAL_COMISION      := lr_datos_debito.TOTAL_COMISION + l_valor_comision;
                lr_datos_debito.TOTAL_RETENCION_IVA := lr_datos_debito.TOTAL_RETENCION_IVA + l_valor_retencion_iva;
                lr_datos_debito.TOTAL_RETENCION_FTE := lr_datos_debito.TOTAL_RETENCION_FTE + l_valor_retencion_fte;
                lr_datos_debito.TOTAL_NETO          := lr_datos_debito.TOTAL_NETO + l_valor_neto;
                --
            END IF;
            --
            --
            IF (lr_debitos_oficina(lr_debito.OFICINA_ID).VALOR_ANTICIPOS is null) then
                lr_debitos_oficina(lr_debito.OFICINA_ID).VALOR_ANTICIPOS:=0;
            END IF;
            --
            --
            IF (lr_debitos_oficina(lr_debito.OFICINA_ID).VALOR_PAGOS is null) then
                lr_debitos_oficina(lr_debito.OFICINA_ID).VALOR_PAGOS:=0;
            END IF;
            --
            --
            IF lr_debito.CODIGO_TIPO_DOCUMENTO='ANT' OR lr_debito.CODIGO_TIPO_DOCUMENTO='ANTC' THEN 
                lr_debitos_oficina(lr_debito.OFICINA_ID).VALOR_ANTICIPOS := 
                    lr_debitos_oficina(lr_debito.OFICINA_ID).VALOR_ANTICIPOS + lr_debito.VALOR_PAGO ;               
                lr_datos_debito.TOTAL_ANTICIPOS := lr_datos_debito.TOTAL_ANTICIPOS + lr_debito.VALOR_PAGO;                  
                
            ELSIF lr_debito.CODIGO_TIPO_DOCUMENTO='PAG' OR lr_debito.CODIGO_TIPO_DOCUMENTO='PAGC' THEN 
                lr_debitos_oficina(lr_debito.OFICINA_ID).VALOR_PAGOS := 
                    lr_debitos_oficina(lr_debito.OFICINA_ID).VALOR_PAGOS + lr_debito.VALOR_PAGO;
                lr_datos_debito.TOTAL_PAGOS := lr_datos_debito.TOTAL_PAGOS + lr_debito.VALOR_PAGO;
            END IF;
            --
            --
            indice:=indice + 1;
            --
            --
            IF Lr_MigraDocumentoAsociado.MIGRACION_ID IS NOT NULL AND Lr_MigraDocumentoAsociado.MIGRACION_ID > 0 THEN
              --
              Lv_MensajeError := NULL;
              --
              NAF47_TNET.GEK_MIGRACION.P_PROCESA_MIGRA_DOC_ASOCIADO(Lr_MigraDocumentoAsociado, 'I', Lv_MensajeError);
              --
              if nvl(Lv_BanderaReplicar,'N') = 'S' AND v_no_cia = Lv_EmpresaOrigen then
                Lr_MigraDocumentoAsociado.MIGRACION_ID := Ln_IdMigracion18;
                Lr_MigraDocumentoAsociado.NO_CIA := Lv_EmpresaDestino;
                
                NAF47_TNET.GEK_MIGRACION.P_PROCESA_MIGRA_DOC_ASOCIADO(Lr_MigraDocumentoAsociado, 'I', Lv_MensajeError);
                
                Lr_MigraDocumentoAsociado.MIGRACION_ID := Ln_IdMigracion33;
                Lr_MigraDocumentoAsociado.NO_CIA := v_no_cia;
                
              end if;
              --
              IF Lv_MensajeError IS NOT NULL THEN
                --
                raise_application_error( -20010, 'Error al insertar la relaci�n del documento migrado en la tabla MIGRA_DOCUMENTO_ASOCIADO. ' ||
                                                 ' DETALLE_PAGO ( ' || lr_debito.ID_PAGO_DET || '). MENSAJE ERROR NAF (' || Lv_MensajeError ||
                                                 ' ).');
                --
              END IF;
              --
            ELSE
              --
              raise_application_error( -20010, 'Error al insertar la relaci�n del documento migrado en la tabla MIGRA_DOCUMENTO_ASOCIADO. ' ||
                                               ' DETALLE_PAGO ( ' || lr_debito.ID_PAGO_DET || '). MENSAJE ERROR ( NO EXISTE ID_MIGRACION ).');
              --
            END IF;
            --
            --
        END LOOP;
        --
        --
        CLOSE C_GetDebitos;
        --
        --
        IF r_plantilla_contable_cab.ID_PLANTILLA_CONTABLE_CAB is NULL THEN
          --
          raise_application_error( -20006, 'No se encontro plantilla disponible para cabecera de asiento' );
          --
        ELSE
          --
          lr_datos_debito.TOTAL    :=  lr_datos_debito.TOTAL_PAGOS +  lr_datos_debito.TOTAL_ANTICIPOS;
          --  
          IF lr_datos_debito.TOTAL <= 0 OR lr_datos_debito.TOTAL IS NULL THEN
            --
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                                  'FNKG_CONTABILIZAR_DEBITOS.PROCESAR_DEBITOS', 
                                                  'No se encontraron valores de pagos para contabilizar. DEBITO_GENERAL HISTORIAL_ID(' || 
                                                  v_debito_gen_histo_id || '), TIPO_BUSQUEDA( ' || Lr_GetDetalleParametros.VALOR2 || ') - ' ||
                                                  SQLCODE || ' -ERROR- ' || SQLERRM,
                                                  NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'), 
                                                  SYSDATE, 
                                                  NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
            --
          ELSE
            --
            --NUMERO CUENTA Y CUENTA CONTABLE DESTINO
            r_cuenta_contable     := FNKG_CONTABILIZAR_PAGO_MANUAL.GET_CUENTA_CONTABLE(lr_datos_debito.CUENTA_CONTABLE_ID);
            l_no_cta_destino      := r_cuenta_contable.NO_CTA;
            l_no_cta_cble_destino := r_cuenta_contable.CUENTA;
            l_no_fisico           := SUBSTR(l_numero_documento, 0, 10);
            l_serie_fisico        := SUBSTR(l_numero_documento, 0, 10);
            --
            l_migra_arckmm.ID_FORMA_PAGO          := r_plantilla_contable_cab.ID_FORMA_PAGO;
            l_migra_arckmm.ID_OFICINA_FACTURACION := lr_datos_debito.OFICINA_ID;
            --
            l_migra_arckmm.NO_CIA          := v_no_cia;
            l_migra_arckmm.NO_CTA          := l_no_cta_destino;
            l_migra_arckmm.PROCEDENCIA     := 'C';
            l_migra_arckmm.TIPO_DOC        := 'NC';
            l_migra_arckmm.NO_DOCU         := Ln_TipoDocumentoId || FNKG_CONTABILIZAR_PAGO_MANUAL.GENERA_NO_DOCU_ASIENTO
                                                                    ( r_plantilla_contable_cab.FORMATO_NO_DOCU_ASIENTO,
                                                                      lr_datos_debito.ID_DEBITO_GENERAL_HISTORIAL,
                                                                      null ); 
            l_migra_arckmm.FECHA           := lr_datos_debito.FE_CREACION;      
            l_migra_arckmm.COMENTARIO      := FNKG_CONTABILIZAR_PAGO_MANUAL.GENERA_COMENTARIO( null, 
                                                                                               '',
                                                                                               r_plantilla_contable_cab.FORMATO_GLOSA,
                                                                                               null,
                                                                                               lr_datos_debito );    
            l_migra_arckmm.MONTO           := lr_datos_debito.TOTAL;
            l_migra_arckmm.ESTADO          := 'P';
            l_migra_arckmm.CONCILIADO      := 'N';
            l_migra_arckmm.MES             := TO_NUMBER(TO_CHAR(lr_datos_debito.FE_CREACION, 'MM'));
            l_migra_arckmm.ANO             := TO_NUMBER(TO_CHAR(lr_datos_debito.FE_CREACION, 'YYYY'));  
            l_migra_arckmm.IND_OTROMOV     := 'S';
            l_migra_arckmm.MONEDA_CTA      := 'P';
            l_migra_arckmm.TIPO_CAMBIO     := '1';
            l_migra_arckmm.T_CAMB_C_V      := 'C';
            l_migra_arckmm.IND_OTROS_MESES := 'N';
            l_migra_arckmm.NO_FISICO       := l_no_fisico;
            l_migra_arckmm.SERIE_FISICO    := l_serie_fisico;    
            l_migra_arckmm.ORIGEN          := l_prefijo;
            l_migra_arckmm.USUARIO_CREACION:= lr_datos_debito.USR_CREACION;     
            l_migra_arckmm.FECHA_DOC       := lr_datos_debito.FE_CREACION;
            l_migra_arckmm.IND_DIVISION    := 'N';
            l_migra_arckmm.FECHA_CREACION  := sysdate;
            l_migra_arckmm.COD_DIARIO      := r_plantilla_contable_cab.COD_DIARIO;
                
            --INSERTA CABECERA DEL ASIENTO
            ----------------------------
            l_MsnError := NULL;
            --
            NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKMM(l_migra_arckmm,l_MsnError);
            --
            --
            IF l_MsnError IS NOT NULL THEN
                raise_application_error( -20003, 'Error al insertar cabecera asiento en MIGRA_ARCKMM' );
            END IF;
            --
            IF nvl(Lv_BanderaReplicar,'N') = 'S' AND v_no_cia = Lv_EmpresaOrigen THEN
              DECLARE
               Ln_IdOficina DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%type;                        
              BEGIN
                select id_oficina INTO Ln_IdOficina
                      from DB_COMERCIAL.INFO_OFICINA_GRUPO b
                     where b.NOMBRE_OFICINA = (select replace(A.NOMBRE_OFICINA, 'ECUANET', 'MEGADATOS')
                                                 from DB_COMERCIAL.INFO_OFICINA_GRUPO a
                                                where a.id_oficina = lr_datos_debito.OFICINA_ID);
                                                
                l_migra_arckmm.ID_OFICINA_FACTURACION := Ln_IdOficina;
                l_migra_arckmm.NO_CIA          := Lv_EmpresaDestino;
                l_migra_arckmm.ID_MIGRACION := Ln_IdMigracion18;
                
                NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKMM(l_migra_arckmm,l_MsnError);
                
                l_migra_arckmm.ID_OFICINA_FACTURACION := lr_datos_debito.OFICINA_ID;
                l_migra_arckmm.NO_CIA          := v_no_cia;
                l_migra_arckmm.ID_MIGRACION := Ln_IdMigracion33;
              
              END;
              
              
              
            END IF;
            --
            --CREA ASIENTOS DE DEBITO
            CREA_ASIENTO_DEBITO_DEBITOS(r_plantilla_contable_cab,l_migra_arckmm,lr_datos_debito,v_no_cia, Lv_MensajeError, Ln_IdMigracion18);
            --
            --
            IF Lv_MensajeError <> 'OK' THEN
              --
              raise_application_error( -20004, 'Error al insertar detalles (D) asiento en MIGRA_ARCKML'||Lv_MensajeError );
              --
            END IF;
            --
            --
            --CREA ASIENTOS DE CREDITO
            CREA_ASIENTO_CREDITO_DEBITOS(r_plantilla_contable_cab,l_migra_arckmm,lr_datos_debito,lr_debitos_oficina,v_no_cia, Lv_MensajeError, Ln_IdMigracion18);
            --
            --
            IF Lv_MensajeError<>'OK' THEN
              --
              raise_application_error( -20004, 'Error al insertar detalles (C) asiento en MIGRA_ARCKML' || Lv_MensajeError );
              --
            END IF;
            --
            --
            MARCA_CONTABILIZADO_PAGO(lr_pagos_debito);
            --
            Pv_Mensaje := 'Proceso OK';
            --
            COMMIT;
            --
          END IF;
          --
        END IF;
        --
      END IF;--Lr_GetDetalleParametros.VALOR2 IS NOT NULL
      --
    END LOOP;--OPEN C_GetDetalleParametros
    --
    CLOSE c_datos_debito;
    --
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    Lv_MensajeError := Lv_MensajeError||' : '|| DBMS_UTILITY.FORMAT_ERROR_STACK;    
    --
    ROLLBACK;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'FNKG_CONTABILIZAR_DEBITOS.PROCESAR_DEBITOS', 
                                          Lv_MensajeError || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
  END PROCESAR_DEBITOS;

/*
* Documentaci�n para FUNCION 'CREA_ASIENTO_DEBITO_DEBITOS'.
* PROCEDIMIENTO QUE CREA LOS DETALLES DE ASIENTOS TIPO DEBITO PARA LOS DEBITOS
* @author Andres Montero amontero@telconet.ec
* @version 1.0
* @since 04/04/2016
*
* @author Luis Lindao <llindao@telconet.ec>
* @version 1.1 06-01-2018
* Se modifica para agregar parametro p_cuenta_contable recuperada la buscar la cuenta bancaria y no hacer doble b�squeda
*
* @Param in FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableCab pt_plantilla_contable_cab (plantilla de cabecera)
* @Param in MIGRA_ARCKMM%ROWTYPE p_migra_arckmm (cabecera de asiento)
* @Param in FNKG_TRANSACTION_CONTABILIZAR.TypeDatosDebito lr_datos_debito (datos del debito)
* @Param out varchar2 msg_ret (string que retorna con resultado de procedimiento)
* @Param in varchar2 p_cuenta_contable (Estrin que viene lleno cuando se contabiliza por banco tipo cuenta)
*/
PROCEDURE CREA_ASIENTO_DEBITO_DEBITOS(
    
    pt_plantilla_contable_cab in FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableCab,
    p_migra_arckmm MIGRA_ARCKMM%ROWTYPE,
    lr_datos_debito in FNKG_TRANSACTION_CONTABILIZAR.TypeDatosDebito,
    p_no_cia varchar2,
    msg_ret out varchar2,
    p_cuenta_contable in varchar2 default null,
    Pn_IdMigracion18 naf47_tnet.migra_arckmm.id_migracion%type default null
    )
IS

    l_no_cta_contable       varchar2(16); 
    l_cta_contable_comision varchar2(15);
    l_cta_contable_retfte   varchar2(15);
    l_cta_contable_retiva   varchar2(15);
    
    c_admi_plantilla_contab_det SYS_REFCURSOR ;
    r_plantilla_contable_det FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableDet;
    r_cuenta_contable FNKG_TRANSACTION_CONTABILIZAR.TypeCuentaContable;
    
    l_migra_arckml MIGRA_ARCKML%ROWTYPE;    
    
    l_MsnError varchar2(500);    
    
    ex_insert_arckml EXCEPTION;
    PRAGMA EXCEPTION_INIT( ex_insert_arckml, -20008 );
    
    Lv_EmpresaOrigen db_general.admi_parametro_det.valor2%type;
    Lv_EmpresaDestino db_general.admi_parametro_det.valor2%type;
    Lv_BanderaReplicar db_general.admi_parametro_det.valor2%type; 
    
BEGIN
  Lv_EmpresaOrigen := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'EMPRESA_ORIGEN');
      Lv_EmpresaDestino := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'EMPRESA_DESTINO');
      Lv_BanderaReplicar := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'APLICA_REPLICA_MIGRACION');
      
    msg_ret:='12100';
    DBMS_OUTPUT.PUT_LINE('buscando plantilla det: '||pt_plantilla_contable_cab.ID_PLANTILLA_CONTABLE_CAB);  
    c_admi_plantilla_contab_det:=
        FNKG_CONTABILIZAR_PAGO_MANUAL.GET_PLANTILLA_CONTABLE_DET_POS(
            pt_plantilla_contable_cab.ID_PLANTILLA_CONTABLE_CAB,'D');
    msg_ret:='12150';
    DBMS_OUTPUT.PUT_LINE('inicio lectura detalles');  
    
    msg_ret:='12200';    
    LOOP    
        msg_ret:='12250'; 
        FETCH c_admi_plantilla_contab_det INTO r_plantilla_contable_det;
        EXIT WHEN c_admi_plantilla_contab_det%NOTFOUND;        
        DBMS_OUTPUT.PUT_LINE('detalle: '||r_plantilla_contable_det.DESCRIPCION);        
        --NUMERO CUENTA Y CUENTA CONTABLE DESTINO
        r_cuenta_contable := FNKG_CONTABILIZAR_PAGO_MANUAL.GET_CUENTA_CONTABLE(lr_datos_debito.CUENTA_CONTABLE_ID);   
        --
        IF r_cuenta_contable.CUENTA IS NULL THEN
          IF r_plantilla_contable_det.TIPO_CUENTA_CONTABLE = 'BANCOS DEBITOS MD' THEN
            IF p_cuenta_contable IS NOT NULL THEN
              l_no_cta_contable := p_cuenta_contable;
            END IF;
          END IF;
        ELSE
          l_no_cta_contable := r_cuenta_contable.CUENTA;
        END IF;
        --
        msg_ret:='12300';       
        l_migra_arckml.NO_CIA         := p_migra_arckmm.NO_CIA;
        l_migra_arckml.COD_DIARIO     := p_migra_arckmm.COD_DIARIO;
        l_migra_arckml.MIGRACION_ID   := p_migra_arckmm.ID_MIGRACION;
        l_migra_arckml.PROCEDENCIA    := 'C';
        l_migra_arckml.TIPO_DOC       := 'NC';
        l_migra_arckml.NO_DOCU        := p_migra_arckmm.NO_DOCU;
        l_migra_arckml.COD_CONT       := l_no_cta_contable;
        l_migra_arckml.CENTRO_COSTO   := '000000000';
        l_migra_arckml.TIPO_CAMBIO    := 1;
        l_migra_arckml.MONEDA         := 'P';
        l_migra_arckml.MODIFICABLE    := 'N';
        l_migra_arckml.ANO            := TO_NUMBER(TO_CHAR(lr_datos_debito.FE_CREACION, 'YYYY'));
        l_migra_arckml.MES            := TO_NUMBER(TO_CHAR(lr_datos_debito.FE_CREACION, 'MM'));      
        msg_ret:='12350';       
        l_migra_arckml.GLOSA          := FNKG_CONTABILIZAR_PAGO_MANUAL.GENERA_COMENTARIO(
                null, '', r_plantilla_contable_det.FORMATO_GLOSA,null,lr_datos_debito);      
            
        msg_ret:='12400'; 

        l_migra_arckml.TIPO_MOV       := 'D';

        IF ((lr_datos_debito.TOTAL_COMISION > 0) OR (lr_datos_debito.TOTAL_RETENCION_FTE > 0) 
            OR (lr_datos_debito.TOTAL_RETENCION_IVA > 0) OR (lr_datos_debito.TOTAL_NETO>0))THEN      
            msg_ret:='12450';         
            IF (INSTR(r_plantilla_contable_det.DESCRIPCION, 'VALOR RETENCION FTE')>0 AND lr_datos_debito.TOTAL_RETENCION_FTE > 0) THEN
                msg_ret:='12450';
                --OBTIENE CUENTA CONTABLE COMISION
                l_cta_contable_retfte   := GET_CUENTA_CONTABLE_POR_DESC('RETENCION FUENTE 2','RETENCION_FTE',p_no_cia);                
                l_migra_arckml.COD_CONT := l_cta_contable_retfte; 
                msg_ret:='12451';             
                l_migra_arckml.MONTO          := lr_datos_debito.TOTAL_RETENCION_FTE;
                l_migra_arckml.MONTO_DOl      := lr_datos_debito.TOTAL_RETENCION_FTE;     
                l_migra_arckml.MONTO_DC       := lr_datos_debito.TOTAL_RETENCION_FTE;
                DBMS_OUTPUT.PUT_LINE('agregando valor retencion fte');                  
                NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKML(l_migra_arckml,l_MsnError);
                msg_ret:='12500';                 
                IF l_MsnError IS NOT NULL THEN
                    raise_application_error( -20008, 'Error al insertar asiento valor ret_fte tipo debito en MIGRA_ARCKML'||l_MsnError);
                    --msg_ret:='Error ret_fte:'||l_MsnError;
                END IF;
                
                if nvl(Lv_BanderaReplicar,'N') = 'S' AND p_no_cia = Lv_EmpresaOrigen then
                  l_migra_arckml.NO_CIA := Lv_EmpresaDestino;
                  l_migra_arckml.MIGRACION_ID := Pn_IdMigracion18;
                  
                  NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKML(l_migra_arckml,l_MsnError);
                  
                  l_migra_arckml.NO_CIA := p_no_cia;
                  l_migra_arckml.MIGRACION_ID := p_migra_arckmm.ID_MIGRACION;
                  
                  IF l_MsnError IS NOT NULL THEN
                    raise_application_error( -20008, 'Error al insertar asiento valor ret_fte tipo debito en MIGRA_ARCKML'||l_MsnError);
                  END IF;
                end if;
                 
                DBMS_OUTPUT.PUT_LINE('valor retencion fte agregado');
            
            ELSIF (INSTR(r_plantilla_contable_det.DESCRIPCION, 'VALOR RETENCION IVA')>0 AND lr_datos_debito.TOTAL_RETENCION_IVA > 0) THEN
                msg_ret:='12550';
                --OBTIENE CUENTA CONTABLE COMISION
                l_cta_contable_retiva   := GET_CUENTA_CONTABLE_POR_DESC('RETENCION IVA 30','RETENCION_IVA',p_no_cia);                
                l_migra_arckml.COD_CONT := l_cta_contable_retiva;                              
                msg_ret:='12551';                
                l_migra_arckml.MONTO          := lr_datos_debito.TOTAL_RETENCION_IVA;
                l_migra_arckml.MONTO_DOl      := lr_datos_debito.TOTAL_RETENCION_IVA;    
                l_migra_arckml.MONTO_DC       := lr_datos_debito.TOTAL_RETENCION_IVA;    
                DBMS_OUTPUT.PUT_LINE('agregando valor retencion iva'); 
                NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKML(l_migra_arckml,l_MsnError);
                
                IF l_MsnError IS NOT NULL THEN
                    --raise_application_error( -20008, 'Error al insertar asiento valor ret_iva tipo debito en MIGRA_ARCKML' );
                    msg_ret:='Error valor ret_iva:'||l_MsnError;
                END IF; 
                
                if nvl(Lv_BanderaReplicar,'N') = 'S' AND p_no_cia = Lv_EmpresaOrigen then
                  l_migra_arckml.NO_CIA := Lv_EmpresaDestino;
                  l_migra_arckml.MIGRACION_ID := Pn_IdMigracion18;
                  
                  NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKML(l_migra_arckml,l_MsnError);
                  
                  l_migra_arckml.NO_CIA := p_no_cia;
                  l_migra_arckml.MIGRACION_ID := p_migra_arckmm.ID_MIGRACION;
                  
                  IF l_MsnError IS NOT NULL THEN
                    raise_application_error( -20008, 'Error al insertar asiento valor ret_fte tipo debito en MIGRA_ARCKML'||l_MsnError);
                  END IF;
                end if;
                
                DBMS_OUTPUT.PUT_LINE('valor retencion iva agregado');                 
            
            ELSIF (INSTR(r_plantilla_contable_det.DESCRIPCION, 'VALOR COMISION BANCARIA')>0 AND lr_datos_debito.TOTAL_COMISION>0) THEN
                msg_ret:='12600';
                l_cta_contable_comision := GET_CUENTA_CONTABLE_POR_DESC('COMISION BANCARIA','COMISION_BCO',p_no_cia);                
                l_migra_arckml.COD_CONT := l_cta_contable_comision; 
                msg_ret:='12601';
                l_migra_arckml.MONTO          := lr_datos_debito.TOTAL_COMISION;
                l_migra_arckml.MONTO_DOl      := lr_datos_debito.TOTAL_COMISION;    
                l_migra_arckml.MONTO_DC       := lr_datos_debito.TOTAL_COMISION;
                DBMS_OUTPUT.PUT_LINE('agregando valor comision');                 
                NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKML(l_migra_arckml,l_MsnError);
                
                IF l_MsnError IS NOT NULL THEN
                    --raise_application_error( -20008, 'Error al insertar asiento valor comision_bco en MIGRA_ARCKML'||l_MsnError );
                    msg_ret:='Error valor comision:'||l_MsnError;
                END IF; 
                
                if nvl(Lv_BanderaReplicar,'N') = 'S' AND p_no_cia = Lv_EmpresaOrigen then
                  l_migra_arckml.NO_CIA := Lv_EmpresaDestino;
                  l_migra_arckml.MIGRACION_ID := Pn_IdMigracion18;
                  
                  NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKML(l_migra_arckml,l_MsnError);
                  
                  l_migra_arckml.NO_CIA := p_no_cia;
                  l_migra_arckml.MIGRACION_ID := p_migra_arckmm.ID_MIGRACION;
                  
                  IF l_MsnError IS NOT NULL THEN
                    raise_application_error( -20008, 'Error al insertar asiento valor ret_fte tipo debito en MIGRA_ARCKML'||l_MsnError);
                  END IF;
                end if;
                DBMS_OUTPUT.PUT_LINE('valor comision agregado');
            ELSIF (INSTR(r_plantilla_contable_det.DESCRIPCION, 'VALOR NETO')>0 AND lr_datos_debito.TOTAL_NETO>0) THEN            
                msg_ret:='12650';
                l_migra_arckml.MONTO          := lr_datos_debito.TOTAL_NETO;
                l_migra_arckml.MONTO_DOl      := lr_datos_debito.TOTAL_NETO;
                l_migra_arckml.MONTO_DC       := lr_datos_debito.TOTAL_NETO; 
                DBMS_OUTPUT.PUT_LINE('agregando valor neto');                            
                NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKML(l_migra_arckml,l_MsnError);
                
                IF l_MsnError IS NOT NULL THEN
                    --raise_application_error( -20008, 'Error al insertar asiento valor neto en MIGRA_ARCKML'||l_MsnError );
                    msg_ret:='Error valor neto:'||l_MsnError;
                END IF;
                
                if nvl(Lv_BanderaReplicar,'N') = 'S' AND p_no_cia = Lv_EmpresaOrigen then
                  l_migra_arckml.NO_CIA := Lv_EmpresaDestino;
                  l_migra_arckml.MIGRACION_ID := Pn_IdMigracion18;
                  
                  NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKML(l_migra_arckml,l_MsnError);
                  
                  l_migra_arckml.NO_CIA := p_no_cia;
                  l_migra_arckml.MIGRACION_ID := p_migra_arckmm.ID_MIGRACION;
                  
                  IF l_MsnError IS NOT NULL THEN
                    raise_application_error( -20008, 'Error al insertar asiento valor ret_fte tipo debito en MIGRA_ARCKML'||l_MsnError);
                  END IF;
                end if;
                
                DBMS_OUTPUT.PUT_LINE('valor neto agregado');
            END IF;

        ELSIF (INSTR(r_plantilla_contable_det.DESCRIPCION, 'VALOR PAGOS')>0 ) THEN
            msg_ret:='12700';            
            l_migra_arckml.MONTO          := lr_datos_debito.TOTAL;
            l_migra_arckml.MONTO_DOl      := lr_datos_debito.TOTAL;
            l_migra_arckml.MONTO_DC       := lr_datos_debito.TOTAL; 
            DBMS_OUTPUT.PUT_LINE('agregando valor pagos');
            NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKML(l_migra_arckml,l_MsnError);
            msg_ret:='12750';            
            IF l_MsnError IS NOT NULL THEN
                --raise_application_error( -20008, 'Error al insertar asiento valor pagos en MIGRA_ARCKML'||l_MsnError );
                msg_ret:='Error valor pagos:'||l_MsnError;
            END IF;
            
            if nvl(Lv_BanderaReplicar,'N') = 'S' AND p_no_cia = Lv_EmpresaOrigen then
                  l_migra_arckml.NO_CIA := Lv_EmpresaDestino;
                  l_migra_arckml.MIGRACION_ID := Pn_IdMigracion18;
                  
                  NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKML(l_migra_arckml,l_MsnError);
                  
                  l_migra_arckml.NO_CIA := p_no_cia;
                  l_migra_arckml.MIGRACION_ID := p_migra_arckmm.ID_MIGRACION;
                  
                  IF l_MsnError IS NOT NULL THEN
                    raise_application_error( -20008, 'Error al insertar asiento valor ret_fte tipo debito en MIGRA_ARCKML'||l_MsnError);
                  END IF;
                end if;
            DBMS_OUTPUT.PUT_LINE('valor pagos agregado');
        END IF;
        
    
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('detalle de debitos agregados');    
    msg_ret:='OK'; 
    CLOSE c_admi_plantilla_contab_det;
    
    EXCEPTION 
        WHEN OTHERS THEN
            msg_ret:=msg_ret||' : '|| DBMS_UTILITY.FORMAT_ERROR_STACK;       
            rollback;  
            DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNKG_CONTABILIZAR', 
                'PROCESAR_DEBITOS.CREA_ASIENTO_DEBITO_DEBITOS',msg_ret||' '||TO_CHAR(SYSTIMESTAMP,'HH24:MI:SS'));     
END CREA_ASIENTO_DEBITO_DEBITOS;





/*
* Documentaci�n para FUNCION 'CREA_ASIENTO_CREDITO_DEBITOS'.
* PROCEDIMIENTO QUE CREA LOS DETALLES DE ASIENTOS TIPO CREDITO PARA LOS DEBITOS
* @author Andres Montero amontero@telconet.ec
* @version 1.0
* @since 04/04/2016
*
* @author Luis Lindao <llindao@telconet.ec>
* @version 1.1 06-01-2018
* Se modifica para agregar parametro Pn_IdDebitoGeneral que no se encuentra en la variable registro lr_datos_debito
* 
* @Param in FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableCab pt_plantilla_contable_cab (plantilla de cabecera)
* @Param in MIGRA_ARCKMM%ROWTYPE p_migra_arckmm (cabecera de asiento)
* @Param in FNKG_TRANSACTION_CONTABILIZAR.TypeDatosDebito lr_datos_debito (datos del debito)
* @Param in tb_debitos_oficinas lr_debitos_oficina (oficinas del debito)
* @Param out varchar2 msg_ret (string que retorna con resultado de procedimiento)
* @Param in varchar2 Pn_IdDebitoGeneral (string solo viene llena cuando se contabiliza por debito general y no por historial d�bito)
*/
PROCEDURE CREA_ASIENTO_CREDITO_DEBITOS(

    pt_plantilla_contable_cab in FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableCab,
    p_migra_arckmm MIGRA_ARCKMM%ROWTYPE,    
    lr_datos_debito in FNKG_TRANSACTION_CONTABILIZAR.TypeDatosDebito,
    lr_debitos_oficina   tb_debitos_oficinas, 
    p_no_cia varchar2,    
    msg_ret out varchar2,
    Pn_IdDebitoGeneral  NUMBER DEFAULT NULL,
    Pn_IdMigracion18 naf47_tnet.migra_arckmm.id_migracion%type default null
)
IS
    l_no_cta_cble_destino varchar2(16) :='';
    l_no_cta_cble_origen  varchar2(16) :='';
    l_no_cta_cble_sf      varchar2(16) :='';
    l_no_cta_contable varchar2(16);
    l_MsnError varchar2(800);
    
    l_migra_arckml MIGRA_ARCKML%ROWTYPE;
    
    lr_oficinas    FNKG_TRANSACTION_CONTABILIZAR.TypeOficinas; 
    
    c_admi_plantilla_contab_det SYS_REFCURSOR ;    
    r_plantilla_contable_det FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableDet;    
    r_cuenta_contable_por_tipo FNKG_TRANSACTION_CONTABILIZAR.TypeCuentaContablePorTipo; 
    
    --cursor debitos por oficina
    CURSOR c_oficinas
    IS
    SELECT 
        ofi.id_oficina, ofi.nombre_oficina
    FROM 
        DB_FINANCIERO.INFO_DEBITO_DET ddet 
        JOIN DB_FINANCIERO.INFO_DEBITO_CAB dcab ON dcab.id_debito_cab=ddet.debito_cab_id
        JOIN DB_FINANCIERO.INFO_PAGO_CAB pcab ON ddet.id_debito_det=pcab.debito_det_id
        JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO ofi ON ofi.id_oficina=pcab.oficina_id
    WHERE 
        pcab.debito_general_historial_id=lr_datos_debito.ID_DEBITO_GENERAL_HISTORIAL
    GROUP BY ofi.id_oficina, ofi.nombre_oficina
    UNION
    SELECT 
        ofi.id_oficina, ofi.nombre_oficina
    FROM 
        DB_FINANCIERO.INFO_DEBITO_CAB dcab 
        JOIN DB_FINANCIERO.INFO_DEBITO_DET ddet ON ddet.debito_cab_id = dcab.id_debito_cab
        JOIN DB_FINANCIERO.INFO_PAGO_CAB pcab ON ddet.id_debito_det=pcab.debito_det_id
        JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO ofi ON ofi.id_oficina=pcab.oficina_id
    WHERE 
        dcab.debito_general_id = Pn_IdDebitoGeneral
    GROUP BY ofi.id_oficina, ofi.nombre_oficina;
    
    Lv_EmpresaOrigen db_general.admi_parametro_det.valor2%type;
    Lv_EmpresaDestino db_general.admi_parametro_det.valor2%type;
    Lv_BanderaReplicar db_general.admi_parametro_det.valor2%type;

BEGIN
  Lv_EmpresaOrigen := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'EMPRESA_ORIGEN');
  Lv_EmpresaDestino := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'EMPRESA_DESTINO');
  Lv_BanderaReplicar := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'APLICA_REPLICA_MIGRACION');
      
DBMS_OUTPUT.PUT_LINE('----------------');     
    msg_ret:='13100';
    c_admi_plantilla_contab_det:=
        FNKG_CONTABILIZAR_PAGO_MANUAL.GET_PLANTILLA_CONTABLE_DET_POS(
            pt_plantilla_contable_cab.ID_PLANTILLA_CONTABLE_CAB,'C');
    msg_ret:='13150';
    --obtenemos prefijo de empresa   
    l_migra_arckml.NO_CIA         := p_migra_arckmm.NO_CIA;
    l_migra_arckml.COD_DIARIO     := p_migra_arckmm.COD_DIARIO;
    l_migra_arckml.MIGRACION_ID   := p_migra_arckmm.ID_MIGRACION;
    l_migra_arckml.PROCEDENCIA    := 'C';
    l_migra_arckml.TIPO_DOC       := 'NC';
    l_migra_arckml.NO_DOCU        := p_migra_arckmm.NO_DOCU;
    l_migra_arckml.CENTRO_COSTO   := '000000000';
    l_migra_arckml.TIPO_MOV       := 'C';
    l_migra_arckml.TIPO_CAMBIO    := 1;
    l_migra_arckml.MONEDA         := 'P';
    l_migra_arckml.MODIFICABLE    := 'S';
    l_migra_arckml.ANO            := TO_NUMBER(TO_CHAR(lr_datos_debito.FE_CREACION, 'YYYY'));
    l_migra_arckml.MES            := TO_NUMBER(TO_CHAR(lr_datos_debito.FE_CREACION, 'MM')); 
    msg_ret:='13200';    
    
   --ASIENTOS DE CREDITO
    OPEN c_oficinas; 
    LOOP
    msg_ret:='13250';
        FETCH c_oficinas INTO lr_oficinas;
            EXIT WHEN c_oficinas%NOTFOUND;             
         msg_ret:='13300';
        dbms_output.put_line('inicio del loop de oficinas'); 
        
        dbms_output.put_line('oficina:'||lr_oficinas.OFICINA_ID);
        dbms_output.put_line(' pagos:'||lr_debitos_oficina(lr_oficinas.OFICINA_ID).VALOR_PAGOS);
        dbms_output.put_line(' anticipos:'||lr_debitos_oficina(lr_oficinas.OFICINA_ID).VALOR_ANTICIPOS);              
           l_no_cta_cble_origen:='';
           l_no_cta_cble_sf    :='';            
         msg_ret:='13350';            
        LOOP
            msg_ret:='13400';    
            FETCH c_admi_plantilla_contab_det INTO r_plantilla_contable_det;
            EXIT WHEN c_admi_plantilla_contab_det%NOTFOUND;

            --CUENTA CONTABLE
            r_cuenta_contable_por_tipo := FNKG_CONTABILIZAR_PAGO_MANUAL.GET_CUENTA_CONTABLE_POR_TIPO(lr_oficinas.OFICINA_ID,
                'ID_OFICINA',r_plantilla_contable_det.TIPO_CUENTA_CONTABLE_ID,p_no_cia);
            l_no_cta_contable          := r_cuenta_contable_por_tipo.CUENTA;  
            
            dbms_output.put_line('cuenta ctable:'||l_no_cta_contable);
            
            msg_ret:='13450';           
            l_migra_arckml.COD_CONT       := l_no_cta_contable;   

           l_migra_arckml.GLOSA          := FNKG_CONTABILIZAR_PAGO_MANUAL.GENERA_COMENTARIO(
            null, lr_debitos_oficina(lr_oficinas.OFICINA_ID).NOMBRE_OFICINA, 
            r_plantilla_contable_det.FORMATO_GLOSA,null,lr_datos_debito);     
            
            
           --REGISTRA CREDITO
          
           IF (INSTR(r_plantilla_contable_det.DESCRIPCION, 'VALOR ANTICIPO')>0 ) AND (lr_debitos_oficina(lr_oficinas.OFICINA_ID).VALOR_ANTICIPOS > 0) THEN
               msg_ret:='13500';  
               --INSERTA CREDITO DEL ASIENTO ANTICIPOS (SALDO A FAVOR)
               --------------------------------------------------------
               l_migra_arckml.MONTO          := lr_debitos_oficina(lr_oficinas.OFICINA_ID).VALOR_ANTICIPOS;
               l_migra_arckml.MONTO_DOl      := lr_debitos_oficina(lr_oficinas.OFICINA_ID).VALOR_ANTICIPOS;     
               l_migra_arckml.MONTO_DC       := lr_debitos_oficina(lr_oficinas.OFICINA_ID).VALOR_ANTICIPOS;
      
               NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKML(l_migra_arckml,l_MsnError);
               msg_ret:='13550';              
               IF l_MsnError IS NOT NULL THEN
                   raise_application_error( -20004, 'Error al insertar asiento Anticipos tipo debito en MIGRA_ARCKML'||l_MsnError );
               END IF;
               
               if nvl(Lv_BanderaReplicar,'N') = 'S' AND p_no_cia = Lv_EmpresaOrigen then
                  l_migra_arckml.NO_CIA := Lv_EmpresaDestino;
                  l_migra_arckml.MIGRACION_ID := Pn_IdMigracion18;
                  
                  NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKML(l_migra_arckml,l_MsnError);
                  
                  l_migra_arckml.NO_CIA := p_no_cia;
                  l_migra_arckml.MIGRACION_ID := p_migra_arckmm.ID_MIGRACION;
                  
                  IF l_MsnError IS NOT NULL THEN
                    raise_application_error( -20008, 'Error al insertar asiento valor ret_fte tipo debito en MIGRA_ARCKML'||l_MsnError);
                  END IF;
                end if;
                
               msg_ret:='13600';            
           END IF;
            
            
           IF (INSTR(r_plantilla_contable_det.DESCRIPCION, 'VALOR PAGOS')>0 ) AND (lr_debitos_oficina(lr_oficinas.OFICINA_ID).VALOR_PAGOS > 0) THEN
                --INSERTA CREDITO DEL ASIENTO DIFERENCIA
                -----------------------------------------
                l_migra_arckml.MONTO          := lr_debitos_oficina(lr_oficinas.OFICINA_ID).VALOR_PAGOS;
                l_migra_arckml.MONTO_DOl      := lr_debitos_oficina(lr_oficinas.OFICINA_ID).VALOR_PAGOS;    
                l_migra_arckml.MONTO_DC       := lr_debitos_oficina(lr_oficinas.OFICINA_ID).VALOR_PAGOS;
                
                NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKML(l_migra_arckml,l_MsnError);
                
                IF l_MsnError IS NOT NULL THEN
                   raise_application_error( -20004, 'Error al insertar asiento diferencia tipo debito en MIGRA_ARCKML'||l_MsnError );
                END IF;
                
                if nvl(Lv_BanderaReplicar,'N') = 'S' AND p_no_cia = Lv_EmpresaOrigen then
                  l_migra_arckml.NO_CIA := Lv_EmpresaDestino;
                  l_migra_arckml.MIGRACION_ID := Pn_IdMigracion18;
                  
                  NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKML(l_migra_arckml,l_MsnError);
                  
                  l_migra_arckml.NO_CIA := p_no_cia;
                  l_migra_arckml.MIGRACION_ID := p_migra_arckmm.ID_MIGRACION;
                  
                  IF l_MsnError IS NOT NULL THEN
                    raise_application_error( -20008, 'Error al insertar asiento valor ret_fte tipo debito en MIGRA_ARCKML'||l_MsnError);
                  END IF;
                end if;
           END IF;  
            
        END LOOP; 
        
        CLOSE c_admi_plantilla_contab_det;  
    
    END LOOP;   
    msg_ret:='OK';
    CLOSE c_oficinas;
    EXCEPTION    
        WHEN OTHERS THEN
            msg_ret:=msg_ret||' : '|| DBMS_UTILITY.FORMAT_ERROR_STACK;       
            rollback;  
            DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNKG_CONTABILIZAR', 
                'PROCESAR_DEBITOS.CREA_ASIENTO_CREDITO_DEBITOS',msg_ret||' '||TO_CHAR(SYSTIMESTAMP,'HH24:MI:SS'));            
END CREA_ASIENTO_CREDITO_DEBITOS;


/*
* Documentaci�n para PROCEDIMIENTO 'MARCA_CONTABILIZADO_PAGO'.
* PROCEDIMIENTO QUE ACTUALIZA LOS DETALLES DE PAGOS COMO YA CONTABILIZADO
* @author Andres Montero amontero@telconet.ec
* @version 1.0
* @since 06/04/2016
* @Param in tb_pagos_debitos lr_pagos_debito (listado de detalles de pagos)
*/
PROCEDURE MARCA_CONTABILIZADO_PAGO(lr_pagos_debito IN tb_pagos_debitos)
IS
BEGIN
   dbms_output.put_line('marcar pagos a contabilizado');       
   FOR i in 0 .. lr_pagos_debito.count -1 LOOP    
       --ACTUALIZA CAMPO CONTABILIZADO DE INFO_PAGO_DET
       UPDATE DB_FINANCIERO.INFO_PAGO_DET SET CONTABILIZADO='S' WHERE ID_PAGO_DET=lr_pagos_debito(i).ID_PAGO_DET;   
       --INSERTA HISTORIAL PARA PAGO
       INSERT INTO DB_FINANCIERO.INFO_PAGO_HISTORIAL 
       VALUES(
           SEQ_INFO_PAGO_HISTORIAL.NEXTVAL,
           lr_pagos_debito(i).ID_PAGO,
           null,
           sysdate,
           'telcos',
           lr_pagos_debito(i).ESTADO_PAGO,
           '[Proceso contable OK]'
       );   
   END LOOP;
   dbms_output.put_line('Finalizo marcar pagos contabilizado');       
END MARCA_CONTABILIZADO_PAGO;



/*
* Documentaci�n para FUNCION 'GET_PORCENTAJE_RETENCIONES'.
* FUNCION QUE OBTIENE EL PORCENTAJE DE RETENCION PARA DEBITOS
* @author Andres Montero amontero@telconet.ec
* @version 1.0
* @since 13/04/2016
* @Param in varchar2 p_empresa_cod (id de empresa)
* @Param in varchar2 p_valor1 (valor para consulta del porcentaje)
*/
FUNCTION GET_PORCENTAJE_RETENCIONES(p_empresa_cod varchar2,p_valor1 varchar2) RETURN number
IS

  CURSOR c_porcentaje_ret_fte (pc_empresa_cod VARCHAR2,p_valor1 VARCHAR2) 
  IS
  SELECT pdet.valor2 FROM 
  DB_GENERAL.ADMI_PARAMETRO_CAB pcab 
  JOIN DB_GENERAL.ADMI_PARAMETRO_DET pdet  ON pcab.id_parametro=pdet.parametro_id
  WHERE
  pdet.VALOR1=p_valor1
  AND pdet.empresa_cod=pc_empresa_cod;

  porcentaje varchar2(50);

BEGIN
    OPEN c_porcentaje_ret_fte(p_empresa_cod,p_valor1); 
    FETCH c_porcentaje_ret_fte INTO porcentaje;
    CLOSE c_porcentaje_ret_fte;

    

    RETURN TO_NUMBER(porcentaje, '9999.99');
END;




/*
* Documentaci�n para FUNCION 'GET_CUENTA_CONTABLE_POR_DESC'.
* FUNCION QUE OBTIENE LA CUENTA CONTABLE POR DESCRIPCION, TIPO CUENTA, EMPRESA y ESTADO
* @author Andres Montero amontero@telconet.ec
* @version 1.0
* @since 29/04/2016
* @Param in varchar2 p_descripcion_cuenta (descripcion cuenta contable)
* @Param in number p_tipo_cuenta (id tipo cuenta contable)
* @Param in varchar2 p_empresa_cod (nombre empresa)
*/
FUNCTION GET_CUENTA_CONTABLE_POR_DESC(p_descripcion_cuenta VARCHAR2, p_tipo_cuenta VARCHAR2, p_empresa_cod VARCHAR2) RETURN VARCHAR2
IS

  CURSOR c_cuenta_contable (p_descripcion_cuenta VARCHAR2,p_tipo_cuenta VARCHAR2,p_empresa_cod VARCHAR2, p_estado VARCHAR2) 
  IS
  SELECT cc.CUENTA FROM 
  DB_FINANCIERO.ADMI_CUENTA_CONTABLE cc 
  JOIN DB_FINANCIERO.ADMI_TIPO_CUENTA_CONTABLE tcc ON cc.tipo_cuenta_contable_id=tcc.id_tipo_cuenta_contable
  WHERE
  cc.descripcion = p_descripcion_cuenta
  AND tcc.descripcion = p_tipo_cuenta 
  AND cc.estado = p_estado;

  v_cuenta_contable VARCHAR2(50);

BEGIN
    OPEN c_cuenta_contable(p_descripcion_cuenta,p_tipo_cuenta,p_empresa_cod,'Activo'); 
    FETCH c_cuenta_contable INTO v_cuenta_contable;
    CLOSE c_cuenta_contable;
    
    RETURN v_cuenta_contable;
END;

  FUNCTION F_GET_CUENTA_CONTABLE_POR_TIPO( Pv_ValorCampoRef     NUMBER,
                                           Pv_NombreCampoRef    VARCHAR2, 
                                           Pv_NombreTipoCtaCble VARCHAR2, 
                                           Pv_NoCia             VARCHAR2
                                         ) RETURN FNKG_TRANSACTION_CONTABILIZAR.TypeCuentaContable IS

    --cursor con informacion de la cuenta contable cuenta puente
    CURSOR c_admi_cuenta_contable IS
      SELECT cc.NO_CIA,
        cc.CUENTA,
        cc.no_cta
      FROM DB_FINANCIERO.ADMI_CUENTA_CONTABLE cc,
        DB_FINANCIERO.ADMI_TIPO_CUENTA_CONTABLE tcc
      WHERE cc.tipo_cuenta_contable_id = tcc.id_tipo_cuenta_contable
      AND tcc.descripcion = Pv_NombreTipoCtaCble
      AND cc.VALOR_CAMPO_REFERENCIAL=Pv_ValorCampoRef
      AND cc.CAMPO_REFERENCIAL=Pv_NombreCampoRef
      AND cc.EMPRESA_COD=Pv_NoCia
      AND cc.ESTADO='Activo';
      
      r_cuenta_contable FNKG_TRANSACTION_CONTABILIZAR.TypeCuentaContable;

  BEGIN
    OPEN c_admi_cuenta_contable;
    FETCH c_admi_cuenta_contable INTO r_cuenta_contable.NO_CIA,r_cuenta_contable.CUENTA, r_cuenta_contable.NO_CTA;
    CLOSE c_admi_cuenta_contable;

    RETURN r_cuenta_contable;

  END;
  
  PROCEDURE P_DEBITOS_MASIVOS_MD  (Pv_NoCia        IN VARCHAR2,
                                   Pv_FechaProceso IN VARCHAR2,
                                   Pv_MensajeError IN OUT VARCHAR2 ) IS
    CURSOR C_DEBITOS  IS
      --
      SELECT IDGH.ID_DEBITO_GENERAL_HISTORIAL
      FROM DB_FINANCIERO.INFO_DEBITO_GENERAL_HISTORIAL IDGH
      JOIN DB_FINANCIERO.INFO_PAGO_CAB IPC
      ON IPC.DEBITO_GENERAL_HISTORIAL_ID = IDGH.ID_DEBITO_GENERAL_HISTORIAL
      WHERE IDGH.FE_CREACION >= TO_TIMESTAMP(Pv_FechaProceso||' 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
      AND IDGH.FE_CREACION <= TO_TIMESTAMP(Pv_FechaProceso||' 23:59:59', 'DD/MM/YYYY HH24:MI:SS')
      AND IPC.EMPRESA_ID = Pv_NoCia
      GROUP BY IDGH.ID_DEBITO_GENERAL_HISTORIAL;
      --
    --
  BEGIN
    --
    Pv_MensajeError := NULL;
    --
    FOR Lr_Debito IN C_DEBITOS LOOP
      --
      DB_FINANCIERO.FNKG_CONTABILIZAR_DEBITOS.PROCESAR_DEBITOS( Pv_NoCia, 
                                                                Lr_Debito.Id_Debito_General_Historial,
                                                                'MANUAL', 
                                                                Pv_MensajeError);
      --
      IF Pv_MensajeError <> 'Proceso OK' THEN
        --
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                              'P_DEBITOS_MASIVOS_MD', 
                                              Pv_MensajeError,
                                              NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                              SYSDATE, 
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
        --
      ELSE
        --
        COMMIT;
        --
      END IF;
      --
      --
    END LOOP;
    --
  EXCEPTION 
  WHEN OTHERS THEN
    --
    Pv_MensajeError := Pv_MensajeError || ' : ' || DBMS_UTILITY.FORMAT_ERROR_STACK;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'MIGRACION_DEBITOS', 
                                          Pv_MensajeError,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --

  END P_DEBITOS_MASIVOS_MD;

  
END FNKG_CONTABILIZAR_DEBITOS;
/
