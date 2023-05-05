CREATE EDITIONABLE PACKAGE               FNKG_CONTABILIZAR_CRUCEANT
AS  --
  /**
  *
  * Documentaci�n para PROCESO 'PROCESA_CRUCE_ANTICIPO'.
  * PROCEDIMIENTO QUE PROCESA ASIENTO CONTABLE PARA EL CRUCE DE UN ANTICIPO
  * @author Andres Montero amontero@telconet.ec
  * @version 1.0
  * @since 30/05/2016
  *
  * Actualizacion: Agregamos historial y marcamos como contabilizado al pago
  * @version 1.1 05/08/2016
  * @author Andres Montero <amontero@telconet.ec>
  *
  * Actualizacion: Se lee la plantilla de cruces de anticipos por tipo de proceso, se elimina condicion: contabilizado "S"
  * @version 1.2 29/08/2016
  * @author Andres Montero <amontero@telconet.ec>
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.3 17-03-2017 - Se quita la funci�n SUBSTR de las columnas 'l_no_fisico' y 'l_serie_fisico' para que el valor ingresado por el usuario
  *                           se pase en su totalidad y se pueda realizar la comparaci�n de lo guardado en TELCOS+ con lo migrado al NAF por el n�mero
  *                           de referencia.
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.4 10-09-2017 - Se agrega la variable 'Pv_EmpresaCod' con el c�digo de la empresa que va a contabilizar el cruce del anticipo.
  *                           Se agrega la funci�n 'NAF47_TNET.GEK_MIGRACION.P_PROCESA_MIGRA_DOC_ASOCIADO' el cual guarda la relaci�n del detalle del
  *                           pago migrado con las tablas del NAF.
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.5 06-10-2017 - Se inicializa variable 'Lr_GetValidaPagoMigrado' para poder validar los documentos no migrados.
  *
  * @param Pv_EmpresaCod IN DB_COMERCIAL.INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE  Codigo de la empresa que va a realizar el cruce del anticipo
  * @param Pn_IdPago     IN DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE  Id del pago que se requiere cruzar
  * @param Pv_MensajeError OUT VARCHAR2  Variable que retorna el mensaje de error en caso de existir
  *
  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.6 27-12-2019 - Se cambia la forma de abrir el cursor C_GetPagos, se corrige error cuando el cursor trae un solo registro e intenta
  *                           continuar con la siguiente interacci�n.
  */
  PROCEDURE PROCESA_CRUCE_ANTICIPO(
      Pv_EmpresaCod IN DB_COMERCIAL.INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE,
      Pn_IdPago     IN DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE,
      Pv_MensajeError OUT VARCHAR2);

  /**
  *
  * Documentaci�n para PROCESO 'CREA_MIGRA_ARCKMM'.
  * PROCEDIMIENTO QUE INSERTA DATOS EN TABLA DE NAF MIGRA_ARCKMM
  * @author Andres Montero amontero@telconet.ec
  * @version 1.0
  * @since 30/05/2016
  *
  * Actualizacion: SE ELIMINA VALOR 9 QUE SE ESTABA CONCATENANDO AL CAMPO NO_DOCU
  * @version 1.1 30/08/2016
  * @author Andres Montero <amontero@telconet.ec>
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.2 12-01-2016 - Se modifica la funci�n para enviar la fecha de cruce del pago la cual se usar� al procesar la contabilidad. Para ello
  *                           se obtiene la fecha de cruce con la funci�n 'DB_FINANCIERO.FNCK_CONSULTS.F_GET_FECHA_CRUCE_PAGO'
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.3 10-08-2017 - Se agregan la funcion implementada en NAF 'NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKMM' para insertar en la tabla
  *                          'MIIGRA_ARCKMM'.
  *
  * @Param in FNKG_TRANSACTION_CONTABILIZAR.TypeDetallePagos         lr_detalle_pago (datos del pago)
  * @Param in FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableCab r_plantilla_contable_cab (datos de la cabecera de la plantilla)
  * @Param in varchar2                                               l_no_fisico (Numero fisico de tabla MIGRA_ARCKMM)
  * @Param in varchar2                                               l_no_docu (campo no_docu de tabla MIGRA_ARCKMM)
  * @Param in varchar2                                               l_serie_fisico (Numero serie fisico de tabla MIGRA_ARCKMM)
  * @Param in NAF47_TNET.MIGRA_ARCKMM%ROWTYPE                        l_migra_arckmm (rowtype de tabla MIGRA_ARCKMM)
  * @Param out varchar2                                              msg_ret (mensaje que retorna al finalizar proceso o cuando se produza un error)
  */
  PROCEDURE CREA_MIGRA_ARCKMM(
      lr_detalle_pago          IN FNKG_TRANSACTION_CONTABILIZAR.TypeDetallePagos,
      r_plantilla_contable_cab IN FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableCab,
      l_no_fisico              IN VARCHAR2,
      l_no_docu                IN VARCHAR2,
      l_serie_fisico           IN VARCHAR2,
      l_migra_arckmm OUT NAF47_TNET.MIGRA_ARCKMM%ROWTYPE,
      msg_ret OUT VARCHAR2 );

  /**
  * Documentaci�n para PROCESO 'CREA_MIGRA_ARCGAE'.
  * PROCEDIMIENTO QUE INSERTA DATOS EN TABLA DE NAF MIGRA_ARCGAE
  * @author Andres Montero amontero@telconet.ec
  * @version 1.0
  * @since 30/05/2016
  *
  * Actualizacion: SE ELIMINA VALOR 9 QUE SE ESTABA CONCATENANDO AL CAMPO NO_ASIENTO
  * @version 1.1 30/08/2016
  * @author Andres Montero <amontero@telconet.ec>
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.2 12-01-2016 - Se modifica la funci�n para enviar la fecha de cruce del pago la cual se usar� al procesar la contabilidad. Para ello
  *                           se obtiene la fecha de cruce con la funci�n 'DB_FINANCIERO.FNCK_CONSULTS.F_GET_FECHA_CRUCE_PAGO'
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.3 10-08-2017 - Se agregan la funcion implementada en NAF 'NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAE' para insertar en las tabla
  *                          'MIGRA_ARCGAE'.
  *
  * @param in FNKG_TRANSACTION_CONTABILIZAR.TypeDetallePagos         lr_detalle_pago (datos del pago)
  * @param in FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableCab r_plantilla_contable_cab (datos de la cabecera de la plantilla)
  * @param in NAF47_TNET.MIGRA_ARCKMM%ROWTYPE                        l_migra_arcgae (rowtype de tabla MIGRA_ARCGAE)
  * @param out varchar2                                              msg_ret (mensaje que retorna al finalizar proceso o cuando se produza un error)
  */
  PROCEDURE CREA_MIGRA_ARCGAE(
      lr_detalle_pago          IN FNKG_TRANSACTION_CONTABILIZAR.TypeDetallePagos,
      r_plantilla_contable_cab IN FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableCab,
      l_migra_arcgae           OUT NAF47_TNET.MIGRA_ARCGAE%ROWTYPE,
      msg_ret                  OUT VARCHAR2 );


/**
*
* Documentaci�n para PROCESO 'CREA_MIGRA_ARCKML'.
* PROCEDIMIENTO QUE INSERTA DATOS EN TABLA DE NAF MIGRA_ARCKML
* @author Andres Montero amontero@telconet.ec
* @version 1.0
* @since 30/05/2016 
* @author Edson Franco <efranco@telconet.ec>
* @version 1.1 10-08-2017 - Se agregan la funcion implementada en NAF 'NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKML' para insertar en las tabla
*                          'MIGRA_ARCKML'.
*
* @Param in FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableCab pt_plantilla_contable_cab (datos de la cabecera de la plantilla)
* @Param in FNKG_TRANSACTION_CONTABILIZAR.TypeDetallePagos         pt_detalle_pago (datos del pago)
* @Param in NAF47_TNET.MIGRA_ARCKMM%ROWTYPE                        pt_migra_arckmm (rowtype de tabla MIGRA_ARCKMM)
* @Param in varchar2                                               l_no_cta_contable (Numero de cuenta contable) 
* @Param in FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableDet r_plantilla_contable_det (datos de los detalles de la plantilla)
* @Param out varchar2                                              msg_ret (mensaje que retorna al finalizar proceso o cuando se produza un error) 
*/
PROCEDURE CREA_MIGRA_ARCKML(
    pt_plantilla_contable_cab in FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableCab,
    pt_detalle_pago in FNKG_TRANSACTION_CONTABILIZAR.TypeDetallePagos,
    pt_migra_arckmm IN NAF47_TNET.MIGRA_ARCKMM%ROWTYPE,
    l_no_cta_contable IN varchar2,
    r_plantilla_contable_det FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableDet,
    msg_ret out varchar2 );


/**
*
* Documentaci�n para PROCESO 'CREA_MIGRA_ARCGAL'.
* PROCEDIMIENTO QUE INSERTA DATOS EN TABLA DE NAF MIGRA_ARCGAL
* @author Andres Montero amontero@telconet.ec
* @version 1.0
* @since 30/05/2016 
*
* Actualizacion: SE GRABA SECUENCIA EN EL CAMPO LINEA DE  TABLA MIGRA_ARCGAL, ANTERIORMENTE SE ESTABA GRABANDO NULL
* @version 1.1 30/08/2016
* @author Andres Montero <amontero@telconet.ec> 
* @author Edson Franco <efranco@telconet.ec>
* @version 1.1 10-08-2017 - Se agregan la funcion implementada en NAF 'NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAL' para insertar en las tabla
*                          'MIGRA_ARCGAL'.
*
* @Param in FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableCab pt_plantilla_contable_cab (datos de la cabecera de la plantilla)
* @Param in FNKG_TRANSACTION_CONTABILIZAR.TypeDetallePagos         pt_detalle_pago (datos del pago)
* @Param in FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableDet r_plantilla_contable_det (datos de los detalles de la plantilla)
* @Param in NAF47_TNET.MIGRA_ARCKMM%ROWTYPE                        pt_migra_arcgae (rowtype de tabla MIGRA_ARCGAE)
* @Param in varchar2                                               l_no_cta_contable (Numero de cuenta contable) 
* @Param in number                                                 l_no_linea (Numero linea) 
* @Param out varchar2                                              msg_ret (mensaje que retorna al finalizar proceso o cuando se produza un error) 
*/    
PROCEDURE CREA_MIGRA_ARCGAL(
    pt_plantilla_contable_cab in FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableCab,
    pt_detalle_pago in FNKG_TRANSACTION_CONTABILIZAR.TypeDetallePagos,
    pt_migra_arcgae IN NAF47_TNET.MIGRA_ARCGAE%ROWTYPE, 
    l_no_cta_contable IN varchar2, 
    Lv_No_Linea IN number,  
    r_plantilla_contable_det FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableDet,    
    msg_ret out varchar2     
);


/**
* 
* Documentaci�n para FUNCION 'CREA_DEBITO_CREDITO'.
* PROCEDIMIENTO QUE CREA EL DEBITO Y CREDITO DEL ASIENTO CONTABLE
* @author Andres Montero amontero@telconet.ec
* @version 1.0
*
* ACTUALIZACION: Se valida que solo para los ANT invierta posicion de asientos
* En caso de otros tipos de documentos debe leer la plantilla que esta
* @author Andres Montero amontero@telconet.ec
*
* @version 1.1 22/07/2016
*
* Actualizacion: Posicion del asiento se asigna tal cual como esta en la plantilla
* @version 1.2 29/08/2016
* @author Andres Montero <amontero@telconet.ec> 
*
* @author Luis Lindao <llindao@telconet.ec> 
* @version 1.3 06-01-2018
* Se modifica para cambiar tipo de dato de variables que recuperan n�mero fisico y serie f�sico pues longitud 
* estaba definida de 20 caracteres y en la tabla es de 40 caracteres.
*
* @since 17/03/2016 
* @Param in  FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableCab r_plantilla_contable_cab (type de cabecera plantilla) 
* @Param in  FNKG_TRANSACTION_CONTABILIZAR.TypeDetallePagos         lr_detalle_pago (type para el detalle del pago) 
* @Param in  MIGRA_ARCKMM%ROWTYPE                                   pt_migra_arckmm (rowtype tabla MIGRA_ARCKMM) 
* @Param in  MIGRA_ARCGAE%ROWTYPE                                   pt_migra_arcgae (rowtype tabla MIGRA_ARCKML) 
* @Param out varchar2                                               msg_ret (mensaje que retorna al finalizar 
*     proceso o cuando se produza un error) 
*/
PROCEDURE CREA_DEBITO_CREDITO(
    pt_plantilla_contable_cab in FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableCab,
    pt_detalle_pago in FNKG_TRANSACTION_CONTABILIZAR.TypeDetallePagos,
    pt_migra_arckmm IN NAF47_TNET.MIGRA_ARCKMM%ROWTYPE,
    pt_migra_arcgae IN NAF47_TNET.MIGRA_ARCGAE%ROWTYPE, 
    msg_ret out varchar2 );


END FNKG_CONTABILIZAR_CRUCEANT;
/

CREATE EDITIONABLE PACKAGE BODY               FNKG_CONTABILIZAR_CRUCEANT
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
  PROCEDURE PROCESA_CRUCE_ANTICIPO(
      Pv_EmpresaCod IN DB_COMERCIAL.INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE,
      Pn_IdPago     IN DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE,
      Pv_MensajeError OUT VARCHAR2)
  IS
    --
    --CURSOR QUE VALIDA QUE EL DETALLE DEL PAGO NO HAYA SIDO MIGRADO
    --COSTO QUERY: 8
    CURSOR C_GetValidaPagoMigrado( Cn_IdPagoDet DB_FINANCIERO.INFO_PAGO_DET.ID_PAGO_DET%TYPE,
                                   Cv_EmpresaCod DB_COMERCIAL.INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE,
                                   Cv_NombrePaqueteSQL DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.NOMBRE_PAQUETE_SQL%TYPE,
                                   Cv_EstadoActivo DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE )
    IS
      --
      SELECT MDA.MIGRACION_ID,
        MDA.DOCUMENTO_ORIGEN_ID,
        MDA.TIPO_DOC_MIGRACION
      FROM NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO MDA
      WHERE MDA.TIPO_DOC_MIGRACION IN
        (SELECT COD_DIARIO
        FROM DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB
        WHERE NOMBRE_PAQUETE_SQL = Cv_NombrePaqueteSQL
        AND EMPRESA_COD          = Cv_EmpresaCod
        AND ESTADO               = Cv_EstadoActivo
        GROUP BY COD_DIARIO
        )
      AND MDA.DOCUMENTO_ORIGEN_ID = Cn_IdPagoDet
      AND MDA.NO_CIA=Cv_EmpresaCod;
      --
    --
    CURSOR C_GetPagos( Cn_IdPago DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE,
                       Cv_EmpresaCod DB_COMERCIAL.INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE,
                       Cv_NombrePaqueteSQL DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.NOMBRE_PAQUETE_SQL%TYPE,
                       Cv_EstadoActivo DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE )
    IS
      --
      SELECT PDET.ID_PAGO_DET AS ID_PAGO_DET, 
        FP.DESCRIPCION_FORMA_PAGO AS FORMA_PAGO,
        FP.CODIGO_FORMA_PAGO AS CODIGO_FORMA_PAGO,
        PDET.VALOR_PAGO AS MONTO,
        PDET.FE_CREACION AS FE_CREACION,
        PCAB.NUMERO_PAGO AS NUMERO_PAGO,
        PDET.NUMERO_CUENTA_BANCO AS NUMERO_CUENTA_BANCO,
        PTO.LOGIN AS LOGIN,
        PCAB.USR_CRUCE AS USR_CREACION,
        OFI.NOMBRE_OFICINA AS OFICINA,
        PDET.CUENTA_CONTABLE_ID AS CUENTA_CONTABLE_ID,
        PDET.NUMERO_REFERENCIA AS NUMERO_REFERENCIA,
        OFI.ID_OFICINA AS OFICINA_ID,
        EMP.PREFIJO AS PREFIJO,
        TDF.CODIGO_TIPO_DOCUMENTO AS TIPO_DOC,
        PDET.PAGO_ID AS PAGO_ID,
        FP.ID_FORMA_PAGO AS ID_FORMA_PAGO,
        TDF.ID_TIPO_DOCUMENTO AS TIPO_DOCUMENTO_ID,
        EMP.COD_EMPRESA AS COD_EMPRESA,
        PDET.FE_DEPOSITO AS FE_DEPOSITO,
        PCAB.PUNTO_ID AS PUNTO_ID,
        PCAB.ESTADO_PAGO AS ESTADO_PAGO,
        0 AS MONTO_ANTICIPOS
      FROM DB_FINANCIERO.INFO_PAGO_DET PDET
      JOIN DB_COMERCIAL.ADMI_FORMA_PAGO FP
      ON PDET.FORMA_PAGO_ID = FP.ID_FORMA_PAGO
      JOIN DB_FINANCIERO.INFO_PAGO_CAB PCAB
      ON PDET.PAGO_ID = PCAB.ID_PAGO
      LEFT JOIN DB_COMERCIAL.INFO_PUNTO PTO
      ON PCAB.PUNTO_ID = PTO.ID_PUNTO
      JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO OFI
      ON PCAB.OFICINA_ID = OFI.ID_OFICINA
      JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO EMP
      ON OFI.EMPRESA_ID = EMP.COD_EMPRESA
      JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO TDF
      ON TDF.ID_TIPO_DOCUMENTO = PCAB.TIPO_DOCUMENTO_ID
      LEFT JOIN NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO MDA
      ON MDA.DOCUMENTO_ORIGEN_ID     = PDET.ID_PAGO_DET
      WHERE PCAB.ID_PAGO             = Cn_IdPago
      AND (MDA.MIGRACION_ID         IS NULL
      OR MDA.TIPO_DOC_MIGRACION NOT IN
        (SELECT COD_DIARIO
        FROM DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB
        WHERE NOMBRE_PAQUETE_SQL = Cv_NombrePaqueteSQL
        AND EMPRESA_COD          = Cv_EmpresaCod
        AND ESTADO               = Cv_EstadoActivo
        GROUP BY COD_DIARIO
        ));
      --
    --
    tablas varchar2(50):='';

    lr_detalle_pago  C_GetPagos%ROWTYPE;

    c_admi_plantilla_contab_det SYS_REFCURSOR ;
    c_pagos_det                 SYS_REFCURSOR ;

    r_plantilla_contable_cab FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableCab;

    l_migra_arckmm NAF47_TNET.MIGRA_ARCKMM%ROWTYPE;
    l_migra_arcgae NAF47_TNET.MIGRA_ARCGAE%ROWTYPE;
    
    l_MsnError varchar2(500);
    l_msn_debito_credito varchar2(500);
    
    l_numero_cuenta_banco NAF47_TNET.MIGRA_ARCKMM.NO_FISICO%TYPE :='0000000000';    
    l_no_fisico           NAF47_TNET.MIGRA_ARCKMM.NO_FISICO%TYPE;
    l_serie_fisico        NAF47_TNET.MIGRA_ARCKMM.SERIE_FISICO%TYPE;
    l_no_cta              varchar2(20) :='';
    l_no_docu             varchar2(50) :='';
    l_cantidad_detalles   number;
    total_anticipo        number     :=0;
    valor_anticipo        number     :=0;
    

    ex_insert_arcgae EXCEPTION;
    PRAGMA EXCEPTION_INIT( ex_insert_arcgae, -20001 );

    ex_insert_arckmm EXCEPTION;
    PRAGMA EXCEPTION_INIT( ex_insert_arckmm, -20003 );   

    ex_no_hay_plantilla EXCEPTION;
    PRAGMA EXCEPTION_INIT( ex_no_hay_plantilla, -20005 ); 

    ex_debito_credito EXCEPTION;
    PRAGMA EXCEPTION_INIT( ex_debito_credito, -20006 ); 


    ex_no_encontro_pago EXCEPTION;
    PRAGMA EXCEPTION_INIT( ex_no_encontro_pago, -20007 );
    --
    Le_MigraDocumentoAsociado EXCEPTION;
    PRAGMA EXCEPTION_INIT( Le_MigraDocumentoAsociado, -20010 );
    --
    Lv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE                := 'VALIDACIONES_PROCESOS_CONTABLES';
    Lv_NombrePaqueteSQL DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.NOMBRE_PAQUETE_SQL%TYPE := 'FNKG_CONTABILIZAR_CRUCEANT';
    Lv_EstadoActivo DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE                             := 'Activo';
    Lr_GetValidaPagoMigrado C_GetValidaPagoMigrado%ROWTYPE;
    Lr_MigraDocumentoAsociado NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO%ROWTYPE;
    --
    Lv_EmpresaOrigen db_general.admi_parametro_det.valor2%type;
    Lv_EmpresaDestino db_general.admi_parametro_det.valor2%type;
    Lv_BanderaReplicar db_general.admi_parametro_det.valor2%type;    
  BEGIN
    Lv_EmpresaOrigen := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'EMPRESA_ORIGEN');
    Lv_EmpresaDestino := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'EMPRESA_DESTINO');
    Lv_BanderaReplicar := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'APLICA_REPLICA_MIGRACION');
    --
    FOR lr_detalle_pago IN C_GetPagos( Pn_IdPago, Pv_EmpresaCod, Lv_NombrePaqueteSQL, Lv_EstadoActivo )
    LOOP
      --
      Pv_MensajeError         := '1000';
      Lr_GetValidaPagoMigrado := NULL;
      --
      IF C_GetValidaPagoMigrado%ISOPEN THEN
        CLOSE C_GetValidaPagoMigrado;
      END IF;
      --
      OPEN C_GetValidaPagoMigrado( lr_detalle_pago.ID_PAGO_DET, Pv_EmpresaCod, Lv_NombrePaqueteSQL, Lv_EstadoActivo );
      --
      FETCH C_GetValidaPagoMigrado INTO Lr_GetValidaPagoMigrado;
      --
      CLOSE C_GetValidaPagoMigrado;
      --
      IF C_GetValidaPagoMigrado%ISOPEN THEN
        CLOSE C_GetValidaPagoMigrado;
      END IF;
      --
      --
      IF Lr_GetValidaPagoMigrado.MIGRACION_ID IS NULL THEN
        --
        --OBTIENE EL NUMERO DE CUENTA O TARJETA DE CREDITO
        IF(lr_detalle_pago.NUMERO_REFERENCIA IS NOT NULL) THEN
           l_numero_cuenta_banco:= lr_detalle_pago.NUMERO_REFERENCIA;
        ELSE
           l_numero_cuenta_banco := '0000000000';
        END IF;      
        --
        l_serie_fisico:=NULL;

        --OBTIENE DATOS DE LA CABECERA DE LA PLANTILLA
        r_plantilla_contable_cab :=
            FNKG_CONTABILIZAR_PAGO_MANUAL.GET_PLANTILLA_CONTABLE_CAB(
              lr_detalle_pago.COD_EMPRESA,
              lr_detalle_pago.ID_FORMA_PAGO , 
              lr_detalle_pago.TIPO_DOCUMENTO_ID,
              'INDIVIDUAL-CRUCE-ANT'
            );

            --GENERA EL NUMERO DE DOCUMENTO
            l_no_docu:=FNKG_CONTABILIZAR_PAGO_MANUAL.GENERA_NO_DOCU_ASIENTO(r_plantilla_contable_cab.FORMATO_NO_DOCU_ASIENTO, 
                lr_detalle_pago.ID_PAGO_DET, lr_detalle_pago);    
            Pv_MensajeError:='1500';    
            --OBTIENE NUMERO FISICO Y SERIE
            IF LENGTH(l_no_docu)>12 AND lr_detalle_pago.CODIGO_FORMA_PAGO <> 'TARC' 
                AND lr_detalle_pago.CODIGO_FORMA_PAGO <> 'TRAN' THEN
                l_no_fisico    := lr_detalle_pago.NUMERO_REFERENCIA;
            Pv_MensajeError:='2000';    
            ELSIF (lr_detalle_pago.CODIGO_FORMA_PAGO = 'TARC' AND lr_detalle_pago.CODIGO_FORMA_PAGO = 'TRAN') THEN

                SELECT count(*) INTO l_cantidad_detalles FROM DB_FINANCIERO.INFO_PAGO_DET WHERE PAGO_ID= lr_detalle_pago.PAGO_ID;  

                l_no_fisico    := REPLACE(lr_detalle_pago.NUMERO_PAGO,'-','') || l_cantidad_detalles;
                l_serie_fisico := NULL;
            ELSE
                l_no_fisico  := l_numero_cuenta_banco;

            END IF; 

             --INGRESA LA CABECERA DEL ASIENTO
             --###############################    
            --
            --
            Lr_MigraDocumentoAsociado.DOCUMENTO_ORIGEN_ID := lr_detalle_pago.ID_PAGO_DET;
            Lr_MigraDocumentoAsociado.TIPO_DOC_MIGRACION  := r_plantilla_contable_cab.COD_DIARIO;
            Lr_MigraDocumentoAsociado.NO_CIA              := lr_detalle_pago.COD_EMPRESA;
            Lr_MigraDocumentoAsociado.FORMA_PAGO_ID       := r_plantilla_contable_cab.ID_FORMA_PAGO;
            Lr_MigraDocumentoAsociado.TIPO_DOCUMENTO_ID   := lr_detalle_pago.TIPO_DOCUMENTO_ID;
            Lr_MigraDocumentoAsociado.ESTADO              := 'M';
            Lr_MigraDocumentoAsociado.USR_CREACION        := lr_detalle_pago.USR_CREACION;
            Lr_MigraDocumentoAsociado.FE_CREACION         := SYSDATE;
            --
            --
            IF (r_plantilla_contable_cab.TABLA_CABECERA='MIGRA_ARCKMM')THEN
              --
              DB_FINANCIERO.FNKG_CONTABILIZAR_CRUCEANT.CREA_MIGRA_ARCKMM( lr_detalle_pago,
                                                                          r_plantilla_contable_cab,
                                                                          l_no_fisico,
                                                                          l_no_docu,
                                                                          l_serie_fisico,
                                                                          l_migra_arckmm,
                                                                          Pv_MensajeError );
              --
              Lr_MigraDocumentoAsociado.MIGRACION_ID   := l_migra_arckmm.ID_MIGRACION;
              Lr_MigraDocumentoAsociado.TIPO_MIGRACION := 'CK';
              --
            ELSIF(r_plantilla_contable_cab.TABLA_CABECERA='MIGRA_ARCGAE')THEN
              --
              DB_FINANCIERO.FNKG_CONTABILIZAR_CRUCEANT.CREA_MIGRA_ARCGAE( lr_detalle_pago,
                                                                          r_plantilla_contable_cab,
                                                                          l_migra_arcgae,
                                                                          Pv_MensajeError );
              --
              Lr_MigraDocumentoAsociado.MIGRACION_ID   := l_migra_arcgae.ID_MIGRACION;
              Lr_MigraDocumentoAsociado.TIPO_MIGRACION := 'CG';
              --
            ELSE
              --
              raise_application_error( -20005, 'No se realiza proceso contable, no se encontro plantilla' );
              --
            END IF;

            --SE CREA LOS DETALLES DEL ASIENTO
            CREA_DEBITO_CREDITO(
                r_plantilla_contable_cab,
                lr_detalle_pago,
                l_migra_arckmm,
                l_migra_arcgae, 
                Pv_MensajeError );  
                
            --ACTUALIZA CAMPO CONTABILIZADO DE INFO_PAGO_DET
            UPDATE DB_FINANCIERO.INFO_PAGO_DET 
            SET CONTABILIZADO = 'S'
            WHERE ID_PAGO_DET = lr_detalle_pago.ID_PAGO_DET; 
            --INSERTA HISTORIAL PARA PAGO
            INSERT INTO DB_FINANCIERO.INFO_PAGO_HISTORIAL 
            VALUES( SEQ_INFO_PAGO_HISTORIAL.NEXTVAL,
              lr_detalle_pago.PAGO_ID,
              null,
              sysdate,
              'telcos',
              lr_detalle_pago.ESTADO_PAGO,
              '['||lr_detalle_pago.CODIGO_FORMA_PAGO||':$'||lr_detalle_pago.MONTO||'][Proceso contable OK]'
            );
          --
          --
          IF Lr_MigraDocumentoAsociado.MIGRACION_ID IS NOT NULL AND Lr_MigraDocumentoAsociado.MIGRACION_ID > 0 THEN
            --
            Pv_MensajeError := NULL;
            --
            NAF47_TNET.GEK_MIGRACION.P_PROCESA_MIGRA_DOC_ASOCIADO(Lr_MigraDocumentoAsociado, 'I', Pv_MensajeError);
            --
            IF Pv_MensajeError IS NOT NULL THEN
              --
              raise_application_error( -20010, 'Error al insertar la relaci�n del documento migrado en la tabla MIGRA_DOCUMENTO_ASOCIADO. ' ||
                                               ' DETALLE_PAGO ( ' || lr_detalle_pago.ID_PAGO_DET || '). MENSAJE ERROR NAF (' || Pv_MensajeError ||
                                               ' ).');
              --
            END IF;
            --
          ELSE
            --
            raise_application_error( -20010, 'Error al insertar la relaci�n del documento migrado en la tabla MIGRA_DOCUMENTO_ASOCIADO. ' ||
                                               ' DETALLE_PAGO ( ' || lr_detalle_pago.ID_PAGO_DET || '). MENSAJE ERROR ( NO EXISTE ID_MIGRACION ).');
            --
          END IF;
          --
        --
      END IF;--Lr_GetValidaPagoMigrado.MIGRACION_ID IS NULL
      --
      ----Si la compa�ia es Ecuanet replica a MD
      IF nvl(Lv_BanderaReplicar,'N') = 'S' AND Pv_EmpresaCod = Lv_EmpresaOrigen THEN--EN migra contabilizacion a MD
      
      lr_detalle_pago.cod_empresa :=  Lv_EmpresaDestino;
      
       BEGIN
       select id_oficina INTO lr_detalle_pago.oficina_id
                              from DB_COMERCIAL.INFO_OFICINA_GRUPO b
                             where b.NOMBRE_OFICINA = (select replace(A.NOMBRE_OFICINA, 'ECUANET', 'MEGADATOS')
                                                         from DB_COMERCIAL.INFO_OFICINA_GRUPO a
                                                        where a.id_oficina =  lr_detalle_pago.oficina_id);
       EXCEPTION
       WHEN OTHERS THEN
         lr_detalle_pago.oficina_id := null;
       END;
      Pv_MensajeError         := '1000';
      Lr_GetValidaPagoMigrado := NULL;
      --
      IF C_GetValidaPagoMigrado%ISOPEN THEN
        CLOSE C_GetValidaPagoMigrado;
      END IF;
      --
      OPEN C_GetValidaPagoMigrado( lr_detalle_pago.ID_PAGO_DET, Lv_EmpresaDestino, Lv_NombrePaqueteSQL, Lv_EstadoActivo );
      --
      FETCH C_GetValidaPagoMigrado INTO Lr_GetValidaPagoMigrado;
      --
      CLOSE C_GetValidaPagoMigrado;
      --
      IF C_GetValidaPagoMigrado%ISOPEN THEN
        CLOSE C_GetValidaPagoMigrado;
      END IF;
      --
      --
      IF Lr_GetValidaPagoMigrado.MIGRACION_ID IS NULL THEN
        --
        --OBTIENE EL NUMERO DE CUENTA O TARJETA DE CREDITO
        IF(lr_detalle_pago.NUMERO_REFERENCIA IS NOT NULL) THEN
           l_numero_cuenta_banco:= lr_detalle_pago.NUMERO_REFERENCIA;
        ELSE
           l_numero_cuenta_banco := '0000000000';
        END IF;      
        --
        l_serie_fisico:=NULL;

        --OBTIENE DATOS DE LA CABECERA DE LA PLANTILLA
        r_plantilla_contable_cab :=
            FNKG_CONTABILIZAR_PAGO_MANUAL.GET_PLANTILLA_CONTABLE_CAB(
              Lv_EmpresaDestino,--MD
              lr_detalle_pago.ID_FORMA_PAGO , 
              lr_detalle_pago.TIPO_DOCUMENTO_ID,
              'INDIVIDUAL-CRUCE-ANT'
            );

            --GENERA EL NUMERO DE DOCUMENTO
            l_no_docu:=FNKG_CONTABILIZAR_PAGO_MANUAL.GENERA_NO_DOCU_ASIENTO(r_plantilla_contable_cab.FORMATO_NO_DOCU_ASIENTO, 
                lr_detalle_pago.ID_PAGO_DET, lr_detalle_pago);    
            Pv_MensajeError:='1500';    
            --OBTIENE NUMERO FISICO Y SERIE
            IF LENGTH(l_no_docu)>12 AND lr_detalle_pago.CODIGO_FORMA_PAGO <> 'TARC' 
                AND lr_detalle_pago.CODIGO_FORMA_PAGO <> 'TRAN' THEN
                l_no_fisico    := lr_detalle_pago.NUMERO_REFERENCIA;
            Pv_MensajeError:='2000';    
            ELSIF (lr_detalle_pago.CODIGO_FORMA_PAGO = 'TARC' AND lr_detalle_pago.CODIGO_FORMA_PAGO = 'TRAN') THEN

                SELECT count(*) INTO l_cantidad_detalles FROM DB_FINANCIERO.INFO_PAGO_DET WHERE PAGO_ID= lr_detalle_pago.PAGO_ID;  

                l_no_fisico    := REPLACE(lr_detalle_pago.NUMERO_PAGO,'-','') || l_cantidad_detalles;
                l_serie_fisico := NULL;
            ELSE
                l_no_fisico  := l_numero_cuenta_banco;

            END IF; 

             --INGRESA LA CABECERA DEL ASIENTO
             --###############################    
            --
            --
            Lr_MigraDocumentoAsociado.DOCUMENTO_ORIGEN_ID := lr_detalle_pago.ID_PAGO_DET;
            Lr_MigraDocumentoAsociado.TIPO_DOC_MIGRACION  := r_plantilla_contable_cab.COD_DIARIO;
            Lr_MigraDocumentoAsociado.NO_CIA              := Lv_EmpresaDestino;--MD
            Lr_MigraDocumentoAsociado.FORMA_PAGO_ID       := r_plantilla_contable_cab.ID_FORMA_PAGO;
            Lr_MigraDocumentoAsociado.TIPO_DOCUMENTO_ID   := lr_detalle_pago.TIPO_DOCUMENTO_ID;
            Lr_MigraDocumentoAsociado.ESTADO              := 'M';
            Lr_MigraDocumentoAsociado.USR_CREACION        := lr_detalle_pago.USR_CREACION;
            Lr_MigraDocumentoAsociado.FE_CREACION         := SYSDATE;
            --
            --
            IF (r_plantilla_contable_cab.TABLA_CABECERA='MIGRA_ARCKMM')THEN
              --
              DB_FINANCIERO.FNKG_CONTABILIZAR_CRUCEANT.CREA_MIGRA_ARCKMM( lr_detalle_pago,
                                                                          r_plantilla_contable_cab,
                                                                          l_no_fisico,
                                                                          l_no_docu,
                                                                          l_serie_fisico,
                                                                          l_migra_arckmm,
                                                                          Pv_MensajeError );
              --
              Lr_MigraDocumentoAsociado.MIGRACION_ID   := l_migra_arckmm.ID_MIGRACION;
              Lr_MigraDocumentoAsociado.TIPO_MIGRACION := 'CK';
              --
            ELSIF(r_plantilla_contable_cab.TABLA_CABECERA='MIGRA_ARCGAE')THEN
              --
              DB_FINANCIERO.FNKG_CONTABILIZAR_CRUCEANT.CREA_MIGRA_ARCGAE( lr_detalle_pago,
                                                                          r_plantilla_contable_cab,
                                                                          l_migra_arcgae,
                                                                          Pv_MensajeError );
              --
              Lr_MigraDocumentoAsociado.MIGRACION_ID   := l_migra_arcgae.ID_MIGRACION;
              Lr_MigraDocumentoAsociado.TIPO_MIGRACION := 'CG';
              --
            ELSE
              --
              raise_application_error( -20005, 'No se realiza proceso contable, no se encontro plantilla' );
              --
            END IF;

            --SE CREA LOS DETALLES DEL ASIENTO
            CREA_DEBITO_CREDITO(
                r_plantilla_contable_cab,
                lr_detalle_pago,
                l_migra_arckmm,
                l_migra_arcgae, 
                Pv_MensajeError );  

            --ACTUALIZA CAMPO CONTABILIZADO DE INFO_PAGO_DET
            UPDATE DB_FINANCIERO.INFO_PAGO_DET 
            SET CONTABILIZADO = 'S'
            WHERE ID_PAGO_DET = lr_detalle_pago.ID_PAGO_DET; 
            --INSERTA HISTORIAL PARA PAGO
            INSERT INTO DB_FINANCIERO.INFO_PAGO_HISTORIAL 
            VALUES( SEQ_INFO_PAGO_HISTORIAL.NEXTVAL,
              lr_detalle_pago.PAGO_ID,
              null,
              sysdate,
              'telcos',
              lr_detalle_pago.ESTADO_PAGO,
              '['||lr_detalle_pago.CODIGO_FORMA_PAGO||':$'||lr_detalle_pago.MONTO||'][Proceso contable OK]'
            );
          --
          --
          IF Lr_MigraDocumentoAsociado.MIGRACION_ID IS NOT NULL AND Lr_MigraDocumentoAsociado.MIGRACION_ID > 0 THEN
            --
            Pv_MensajeError := NULL;
            --
            NAF47_TNET.GEK_MIGRACION.P_PROCESA_MIGRA_DOC_ASOCIADO(Lr_MigraDocumentoAsociado, 'I', Pv_MensajeError);
            --
            IF Pv_MensajeError IS NOT NULL THEN
              --
              raise_application_error( -20010, 'Error al insertar la relaci�n del documento migrado en la tabla MIGRA_DOCUMENTO_ASOCIADO. ' ||
                                               ' DETALLE_PAGO ( ' || lr_detalle_pago.ID_PAGO_DET || '). MENSAJE ERROR NAF (' || Pv_MensajeError ||
                                               ' ).');
              --
            END IF;
            --
          ELSE
            --
            raise_application_error( -20010, 'Error al insertar la relaci�n del documento migrado en la tabla MIGRA_DOCUMENTO_ASOCIADO. ' ||
                                               ' DETALLE_PAGO ( ' || lr_detalle_pago.ID_PAGO_DET || '). MENSAJE ERROR ( NO EXISTE ID_MIGRACION ).');
            --
          END IF;
          --
        --
      END IF;--Lr_GetValidaPagoMigrado.MIGRACION_ID IS NULL
      
      END IF;
      --
    END LOOP;
        	Pv_MensajeError:='PROCESO OK';
  EXCEPTION 
  WHEN OTHERS THEN
    --
    Pv_MensajeError := Pv_MensajeError || ' : ' || DBMS_UTILITY.FORMAT_ERROR_STACK;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'FNKG_CONTABILIZAR_CRUCEANT.PROCESA_CRUCE_ANTICIPO', 
                                          Pv_MensajeError,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
    ROLLBACK;
    --
  END PROCESA_CRUCE_ANTICIPO;







PROCEDURE CREA_MIGRA_ARCKMM(
    lr_detalle_pago IN FNKG_TRANSACTION_CONTABILIZAR.TypeDetallePagos,
    r_plantilla_contable_cab IN FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableCab,
    l_no_fisico IN varchar2, 
    l_no_docu IN VARCHAR2, 
    l_serie_fisico IN VARCHAR2, 
    l_migra_arckmm OUT NAF47_TNET.MIGRA_ARCKMM%ROWTYPE,
    msg_ret OUT varchar2
)
IS
  --
  r_cuenta_contable   FNKG_TRANSACTION_CONTABILIZAR.TypeCuentaContable;
  l_no_cta            VARCHAR2(20) :=''; 
  l_MsnError          VARCHAR2(500);
  Lt_FeCruceDocumento DB_FINANCIERO.INFO_PAGO_CAB.FE_CRUCE%TYPE;
  --
BEGIN

    msg_ret:='1330';
    --NUMERO CUENTA DEL BANCO
    r_cuenta_contable:=FNKG_CONTABILIZAR_PAGO_MANUAL.GET_CUENTA_CONTABLE(lr_detalle_pago.CUENTA_CONTABLE_ID);   
    l_no_cta:= r_cuenta_contable.NO_CTA;

    -- OBTENER LA FECHA DE CRUCE PARA LOS PAGOS
    Lt_FeCruceDocumento := DB_FINANCIERO.FNCK_CONSULTS.F_GET_FECHA_CRUCE_PAGO(NULL, lr_detalle_pago.ID_PAGO_DET);
    --
    l_migra_arckmm.ID_FORMA_PAGO          := lr_detalle_pago.ID_FORMA_PAGO;
    l_migra_arckmm.ID_OFICINA_FACTURACION := lr_detalle_pago.OFICINA_ID;
    --
    l_migra_arckmm.ID_MIGRACION    := NAF47_TNET.TRANSA_ID.MIGRA_CK( lr_detalle_pago.COD_EMPRESA );
    l_migra_arckmm.NO_CIA          := lr_detalle_pago.COD_EMPRESA;
    l_migra_arckmm.NO_CTA          := l_no_cta;
    l_migra_arckmm.PROCEDENCIA     := 'C';
    l_migra_arckmm.TIPO_DOC        := r_plantilla_contable_cab.TIPO_DOC;
    l_migra_arckmm.COD_DIARIO      := r_plantilla_contable_cab.COD_DIARIO;
    l_migra_arckmm.NO_DOCU         := l_no_docu;
    l_migra_arckmm.FECHA           := Lt_FeCruceDocumento;      
    l_migra_arckmm.COMENTARIO      := FNKG_CONTABILIZAR_PAGO_MANUAL.GENERA_COMENTARIO(lr_detalle_pago, '', r_plantilla_contable_cab.FORMATO_GLOSA,null,null);
    l_migra_arckmm.MONTO           := lr_detalle_pago.MONTO + lr_detalle_pago.MONTO_ANTICIPOS;
    l_migra_arckmm.ESTADO          := 'P';
    l_migra_arckmm.CONCILIADO      := 'N';
    l_migra_arckmm.MES             := TO_NUMBER(TO_CHAR(Lt_FeCruceDocumento,'MM'));
    l_migra_arckmm.ANO             := TO_NUMBER(TO_CHAR(Lt_FeCruceDocumento,'YYYY'));  
    l_migra_arckmm.IND_OTROMOV     := 'S';
    l_migra_arckmm.MONEDA_CTA      := 'P';
    l_migra_arckmm.TIPO_CAMBIO     := '1';
    l_migra_arckmm.T_CAMB_C_V      := 'C';
    l_migra_arckmm.IND_OTROS_MESES := 'N';
    l_migra_arckmm.NO_FISICO       := l_no_fisico;   
    l_migra_arckmm.ORIGEN          := lr_detalle_pago.PREFIJO;
    l_migra_arckmm.USUARIO_CREACION:= lr_detalle_pago.USR_CREACION;     
    l_migra_arckmm.FECHA_DOC       := Lt_FeCruceDocumento;
    l_migra_arckmm.IND_DIVISION    := 'N';
    l_migra_arckmm.FECHA_CREACION  := sysdate;
    
    msg_ret:='1335';
    
    dbms_output.put_line('NO_DOCU:'||l_migra_arckmm.NO_DOCU||',  NO_CTA:'||l_migra_arckmm.NO_CTA);
    
    IF (l_migra_arckmm.NO_DOCU IS NOT NULL AND l_migra_arckmm.NO_CTA IS NOT NULL) THEN
    
        --INSERTA CABECERA DEL ASIENTO
        NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKMM(l_migra_arckmm,l_MsnError);
        --
        l_MsnError := 'OK';
        --
        IF (l_serie_fisico IS NOT NULL) THEN
            l_migra_arckmm.SERIE_FISICO:=l_serie_fisico;
            FNKG_TRANSACTION_CONTABILIZAR.UPDATE_MIGRA_ARCKMM(l_no_docu,lr_detalle_pago.COD_EMPRESA,l_migra_arckmm,l_MsnError);
        END IF;  
    
    ELSE   
      raise_application_error( -20006, 'No se realiza proceso contable, faltan datos para crear asiento' );
    
    END IF;
    
    IF(l_MsnError <> 'OK') THEN                  
        raise_application_error( -20003, 'Error al insertar cabecera asiento en MIGRA_ARCKMM: '||l_MsnError );           
    END IF;
    
    msg_ret:='1340'; 
    EXCEPTION 
        WHEN OTHERS THEN
            msg_ret:=msg_ret||' : '|| DBMS_UTILITY.FORMAT_ERROR_STACK;
            DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNKG_CONTABILIZAR_CRUCEANT', 
                'CREA_MIGRA_ARCKMM',msg_ret);
            rollback;
END CREA_MIGRA_ARCKMM;





PROCEDURE CREA_MIGRA_ARCGAE(
    lr_detalle_pago IN FNKG_TRANSACTION_CONTABILIZAR.TypeDetallePagos,
    r_plantilla_contable_cab IN FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableCab,
    l_migra_arcgae OUT NAF47_TNET.MIGRA_ARCGAE%ROWTYPE,
    msg_ret OUT varchar2
)
IS
  --
  l_MsnError          VARCHAR2(500);
  Lt_FeCruceDocumento DB_FINANCIERO.INFO_PAGO_CAB.FE_CRUCE%TYPE;
  --
BEGIN
  --
  -- OBTENER LA FECHA DE CRUCE PARA LOS PAGOS
  Lt_FeCruceDocumento := DB_FINANCIERO.FNCK_CONSULTS.F_GET_FECHA_CRUCE_PAGO(NULL, lr_detalle_pago.ID_PAGO_DET);
  
  l_migra_arcgae.ID_MIGRACION     := NAF47_TNET.TRANSA_ID.MIGRA_CG( lr_detalle_pago.COD_EMPRESA );
  --
  l_migra_arcgae.ID_FORMA_PAGO          := lr_detalle_pago.ID_FORMA_PAGO;
  l_migra_arcgae.ID_OFICINA_FACTURACION := lr_detalle_pago.OFICINA_ID;
  --
  l_migra_arcgae.NO_CIA           := lr_detalle_pago.COD_EMPRESA;
  l_migra_arcgae.ANO              := TO_CHAR(Lt_FeCruceDocumento,'YYYY');
  l_migra_arcgae.MES              := TO_CHAR(Lt_FeCruceDocumento,'MM');
  l_migra_arcgae.NO_ASIENTO       := FNKG_CONTABILIZAR_PAGO_MANUAL.GENERA_NO_DOCU_ASIENTO(r_plantilla_contable_cab.FORMATO_NO_DOCU_ASIENTO, 
                                                                                          lr_detalle_pago.ID_PAGO_DET, 
                                                                                          lr_detalle_pago);
  l_migra_arcgae.IMPRESO          := 'N';
  l_migra_arcgae.FECHA            := Lt_FeCruceDocumento;
  l_migra_arcgae.DESCRI1          := FNKG_CONTABILIZAR_PAGO_MANUAL.GENERA_COMENTARIO(lr_detalle_pago, 
                                                                                     l_migra_arcgae.NO_ASIENTO , 
                                                                                     r_plantilla_contable_cab.FORMATO_GLOSA,
                                                                                     null,
                                                                                     null);
  l_migra_arcgae.ESTADO           := 'P';
  l_migra_arcgae.AUTORIZADO       := 'N';
  l_migra_arcgae.ORIGEN           := lr_detalle_pago.PREFIJO;
  l_migra_arcgae.T_DEBITOS        := lr_detalle_pago.MONTO + lr_detalle_pago.MONTO_ANTICIPOS;
  l_migra_arcgae.T_CREDITOS       := lr_detalle_pago.MONTO + lr_detalle_pago.MONTO_ANTICIPOS;
  l_migra_arcgae.COD_DIARIO       := r_plantilla_contable_cab.COD_DIARIO;
  l_migra_arcgae.T_CAMB_C_V       := 'C';
  l_migra_arcgae.TIPO_CAMBIO      := '1';
  l_migra_arcgae.TIPO_COMPROBANTE := 'T';
  l_migra_arcgae.ANULADO          := 'N';
  l_migra_arcgae.USUARIO_CREACION := lr_detalle_pago.USR_CREACION;
  l_migra_arcgae.TRANSFERIDO      := 'N';
  l_migra_arcgae.FECHA_CREACION   := sysdate;


--INSERTA CABECERA DEL ASIENTO
----------------------------
IF (l_migra_arcgae.NO_ASIENTO IS NOT NULL) THEN 

    NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAE(l_migra_arcgae,l_MsnError);

ELSE                                
  raise_application_error( -20006, 'No se realiza proceso contable, faltan datos para crear asiento' );

END IF;            
IF l_MsnError IS NOT NULL THEN
    raise_application_error( -20001, 'Error al insertar cabecera en MIGRA_ARCGAE:'||l_MsnError );           
END IF;
EXCEPTION 
    WHEN OTHERS THEN
        msg_ret:=msg_ret||' : '|| DBMS_UTILITY.FORMAT_ERROR_STACK;
        DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNKG_CONTABILIZAR_CRUCEANT', 
            'CREA_MIGRA_ARCGAE',msg_ret);
        rollback;

END CREA_MIGRA_ARCGAE;





PROCEDURE CREA_MIGRA_ARCKML(
    pt_plantilla_contable_cab in FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableCab,
    pt_detalle_pago in FNKG_TRANSACTION_CONTABILIZAR.TypeDetallePagos,
    pt_migra_arckmm IN NAF47_TNET.MIGRA_ARCKMM%ROWTYPE,
    l_no_cta_contable IN varchar2,
    r_plantilla_contable_det FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableDet,
    msg_ret out varchar2 )
IS
    l_MsnError        varchar2(500);      
    l_cc1             varchar2(3):='000';
    l_cc2             varchar2(3):='000';
    l_cc3             varchar2(3):='000';    
    l_migra_arckml NAF47_TNET.MIGRA_ARCKML%ROWTYPE;   
BEGIN
    l_migra_arckml.NO_CIA         := pt_migra_arckmm.NO_CIA;
    l_migra_arckml.COD_DIARIO     := pt_migra_arckmm.COD_DIARIO;
    l_migra_arckml.MIGRACION_ID   := pt_migra_arckmm.ID_MIGRACION;
    l_migra_arckml.PROCEDENCIA    := 'C';
    l_migra_arckml.TIPO_DOC       := pt_migra_arckmm.TIPO_DOC;
    l_migra_arckml.NO_DOCU        := pt_migra_arckmm.NO_DOCU;
    l_migra_arckml.COD_CONT       := l_no_cta_contable;
    l_migra_arckml.CENTRO_COSTO   := l_cc1||l_cc2||l_cc3;
    l_migra_arckml.TIPO_MOV       := 'D';
    l_migra_arckml.TIPO_CAMBIO    := 1;
    l_migra_arckml.MONEDA         := 'P';
    l_migra_arckml.MODIFICABLE    := 'N';
    l_migra_arckml.ANO            := pt_migra_arckmm.ANO;
    l_migra_arckml.MES            := pt_migra_arckmm.MES;      
    msg_ret:='1565';                
    l_migra_arckml.GLOSA          := FNKG_CONTABILIZAR_PAGO_MANUAL.GENERA_COMENTARIO(pt_detalle_pago, '', r_plantilla_contable_det.FORMATO_GLOSA,null,null);
    msg_ret:='1570'; 
    l_migra_arckml.TIPO_MOV       := r_plantilla_contable_det.POSICION;                    
    l_migra_arckml.MONTO          := pt_detalle_pago.MONTO;
    l_migra_arckml.MONTO_DOl      := pt_detalle_pago.MONTO;
    l_migra_arckml.MONTO_DC       := pt_detalle_pago.MONTO;
    
    --INSERTA DEBITO O CREDITO DEL ASIENTO
    ----------------------------
    NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKML(l_migra_arckml, l_MsnError);
    
    msg_ret:='1580'; 
    
    IF l_MsnError IS NOT NULL THEN                         
        raise_application_error( -20008, 'Error al insertar asiento tipo '
            || r_plantilla_contable_det.POSICION ||' en MIGRA_ARCKML' );
    END IF; 
    EXCEPTION 
        WHEN OTHERS THEN
            msg_ret:=msg_ret||' : '|| DBMS_UTILITY.FORMAT_ERROR_STACK;
            DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNKG_CONTABILIZAR_CRUCEANT', 
                'CREA_MIGRA_ARCKML',msg_ret);
            rollback;
END CREA_MIGRA_ARCKML;




PROCEDURE CREA_MIGRA_ARCGAL(
  pt_plantilla_contable_cab in FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableCab,
  pt_detalle_pago in FNKG_TRANSACTION_CONTABILIZAR.TypeDetallePagos,
  pt_migra_arcgae IN NAF47_TNET.MIGRA_ARCGAE%ROWTYPE, 
  l_no_cta_contable IN varchar2,  
  Lv_No_Linea IN number,
  r_plantilla_contable_det FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableDet,    
  msg_ret out varchar2     
)
IS
    l_MsnError        varchar2(500);    
    l_cc1             varchar2(3):='000';
    l_cc2             varchar2(3):='000';
    l_cc3             varchar2(3):='000';     
    l_valor_tipo      number     := 1;    
    l_migra_arcgal NAF47_TNET.MIGRA_ARCGAL%ROWTYPE;   
BEGIN

    IF(pt_detalle_pago.CODIGO_FORMA_PAGO='PROI')THEN
        l_cc1:='200';
        l_cc2:='002';
        l_cc3:='001';
    END IF;

    if r_plantilla_contable_det.POSICION='C' then
        l_valor_tipo:=-1;
    else
        l_valor_tipo:=1;
    end if;

    l_migra_arcgal.NO_CIA                 := pt_migra_arcgae.NO_CIA;
    l_migra_arcgal.MIGRACION_ID           := pt_migra_arcgae.ID_MIGRACION;
    l_migra_arcgal.ANO                    := pt_migra_arcgae.ANO;
    l_migra_arcgal.MES                    := pt_migra_arcgae.MES;
    l_migra_arcgal.NO_ASIENTO             := pt_migra_arcgae.NO_ASIENTO;
    l_migra_arcgal.NO_LINEA               := Lv_No_Linea;
    l_migra_arcgal.CUENTA                 := l_no_cta_contable;
    l_migra_arcgal.DESCRI                 := FNKG_CONTABILIZAR_PAGO_MANUAL.GENERA_COMENTARIO(pt_detalle_pago, l_migra_arcgal.NO_ASIENTO, r_plantilla_contable_det.FORMATO_GLOSA,null,null);
    l_migra_arcgal.COD_DIARIO             := pt_migra_arcgae.COD_DIARIO;
    l_migra_arcgal.MONEDA                 := 'P';
    l_migra_arcgal.TIPO_CAMBIO            := 1;
    l_migra_arcgal.CENTRO_COSTO           := l_cc1||l_cc2||l_cc3;
    l_migra_arcgal.TIPO                   := 'D';
    l_migra_arcgal.CC_1                   := l_cc1;
    l_migra_arcgal.CC_2                   := l_cc2;
    l_migra_arcgal.CC_3                   := l_cc3;
    l_migra_arcgal.LINEA_AJUSTE_PRECISION := 'N';      
    l_migra_arcgal.MONTO                  :=0;
    l_migra_arcgal.MONTO_DOl              :=0;
    msg_ret:='1591'; 
    
    l_migra_arcgal.TIPO   := r_plantilla_contable_det.POSICION;            
    
    msg_ret:='1592';
    
    IF (r_plantilla_contable_det.POSICION = 'C') THEN 
    --INSERTA DEBITO O CREDITO DEL ASIENTO
    ----------------------------
        msg_ret:='1596';
        l_migra_arcgal.MONTO     := pt_detalle_pago.MONTO * l_valor_tipo;
        l_migra_arcgal.MONTO_DOl := pt_detalle_pago.MONTO * l_valor_tipo;
    ELSE
        l_migra_arcgal.MONTO     := pt_detalle_pago.MONTO + pt_detalle_pago.MONTO_ANTICIPOS;
        l_migra_arcgal.MONTO_DOl := pt_detalle_pago.MONTO + pt_detalle_pago.MONTO_ANTICIPOS;                    
    END IF;
    NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAL(l_migra_arcgal,l_MsnError);
    msg_ret:='1597';

    IF l_MsnError IS NOT NULL THEN
        msg_ret:='1598';                                                    
        raise_application_error( -20007, 'Error al insertar asiento tipo  '
            || r_plantilla_contable_det.POSICION ||' en MIGRA_ARCGAL' ); 
        msg_ret:='1599';    
    END IF;  
    
    EXCEPTION 
        WHEN OTHERS THEN
            msg_ret:=msg_ret||' : '|| DBMS_UTILITY.FORMAT_ERROR_STACK;
            DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNKG_CONTABILIZAR_CRUCEANT', 
                'CREA_MIGRA_ARCGAL',msg_ret);
            rollback;
            
END CREA_MIGRA_ARCGAL;




PROCEDURE CREA_DEBITO_CREDITO(
    pt_plantilla_contable_cab in FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableCab,
    pt_detalle_pago in FNKG_TRANSACTION_CONTABILIZAR.TypeDetallePagos,
    pt_migra_arckmm IN NAF47_TNET.MIGRA_ARCKMM%ROWTYPE,
    pt_migra_arcgae IN NAF47_TNET.MIGRA_ARCGAE%ROWTYPE, 
    msg_ret out varchar2 )
IS
    c_admi_plantilla_contab_det SYS_REFCURSOR ;
    c_pagos_det                 SYS_REFCURSOR ;
    
    r_cuenta_contable FNKG_TRANSACTION_CONTABILIZAR.TypeCuentaContable;
    r_cuenta_contable_por_tipo FNKG_TRANSACTION_CONTABILIZAR.TypeCuentaContablePorTipo;    
    r_plantilla_contable_det FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableDet;
    r_detalle_anticipos FNKG_TRANSACTION_CONTABILIZAR.TypeDetallePagos;
    
    l_migra_arckml NAF47_TNET.MIGRA_ARCKML%ROWTYPE;
    l_migra_arcgal NAF47_TNET.MIGRA_ARCGAL%ROWTYPE;    
    
    l_MsnError        varchar2(500);    
    l_no_linea        number;
    l_no_cta_contable varchar2(16);      
    
    ex_insert_arcgal EXCEPTION;
    PRAGMA EXCEPTION_INIT( ex_insert_arcgal, -20007 );
    
    ex_insert_arckml EXCEPTION;
    PRAGMA EXCEPTION_INIT( ex_insert_arckml, -20008 ); 
    
    ex_no_existe_cuenta EXCEPTION;
    PRAGMA EXCEPTION_INIT( ex_no_existe_cuenta, -20009 );     
    
BEGIN
    l_no_linea:=0;

    --RECORRE LOS DETALLES DE LA PLANTILLA
    --###################################
    
    c_admi_plantilla_contab_det:=FNKG_CONTABILIZAR_PAGO_MANUAL.GET_PLANTILLA_CONTABLE_DET(pt_plantilla_contable_cab.ID_PLANTILLA_CONTABLE_CAB);
    DBMS_OUTPUT.PUT_LINE('inicio lectura detalles');  
    LOOP
    
    FETCH c_admi_plantilla_contab_det INTO r_plantilla_contable_det;
    msg_ret:='1530'; 
    EXIT WHEN c_admi_plantilla_contab_det%NOTFOUND;               
    DBMS_OUTPUT.PUT_LINE('ctaContable:'||r_plantilla_contable_det.TIPO_CUENTA_CONTABLE_ID);
    
    --OBTIENE LA CUENTA CONTABLE  
    IF r_plantilla_contable_det.TIPO_CUENTA_CONTABLE = 'BANCOS' THEN
        msg_ret:='1540';
        r_cuenta_contable:=FNKG_CONTABILIZAR_PAGO_MANUAL.GET_CUENTA_CONTABLE(pt_detalle_pago.CUENTA_CONTABLE_ID);   
        l_no_cta_contable:= r_cuenta_contable.CUENTA;   
    ELSIF r_plantilla_contable_det.TIPO_CUENTA_CONTABLE = 'FORMA PAGO' THEN
        msg_ret:='1540';
        r_cuenta_contable_por_tipo := FNKG_CONTABILIZAR_PAGO_MANUAL.GET_CUENTA_CONTABLE_POR_TIPO(pt_detalle_pago.ID_FORMA_PAGO,
            'ID_FORMA_PAGO',r_plantilla_contable_det.TIPO_CUENTA_CONTABLE_ID,pt_detalle_pago.COD_EMPRESA);
        l_no_cta_contable          := r_cuenta_contable_por_tipo.CUENTA;           
    ELSE
        msg_ret:='1550'; 
        r_cuenta_contable_por_tipo := FNKG_CONTABILIZAR_PAGO_MANUAL.GET_CUENTA_CONTABLE_POR_TIPO(pt_detalle_pago.OFICINA_ID,
            'ID_OFICINA',r_plantilla_contable_det.TIPO_CUENTA_CONTABLE_ID,pt_detalle_pago.COD_EMPRESA);
        l_no_cta_contable          := r_cuenta_contable_por_tipo.CUENTA;
    END IF;


        msg_ret:='1560'; 
    DBMS_OUTPUT.PUT_LINE('l_no_cta_contable:'||l_no_cta_contable); 
        
        IF(l_no_cta_contable is not null) THEN
            DBMS_OUTPUT.PUT_LINE('entro por cuenta contable llena');  



            IF(pt_plantilla_contable_cab.TABLA_DETALLE='MIGRA_ARCKML')THEN   
            
                DBMS_OUTPUT.PUT_LINE('MIGRA_ARCKML');      

                CREA_MIGRA_ARCKML(
                    pt_plantilla_contable_cab,pt_detalle_pago,pt_migra_arckmm,l_no_cta_contable,r_plantilla_contable_det,msg_ret
                );                
                
                
            ELSIF(pt_plantilla_contable_cab.TABLA_DETALLE='MIGRA_ARCGAL')THEN
    
                msg_ret    := '1590'; 
                l_no_linea := l_no_linea + 1;                
                CREA_MIGRA_ARCGAL(
                  pt_plantilla_contable_cab,
                  pt_detalle_pago,
                  pt_migra_arcgae, 
                  l_no_cta_contable,
                  l_no_linea,
                  r_plantilla_contable_det,
                  msg_ret   
                );
            END IF;
        
        ELSE                                                     
            raise_application_error( -20009, 'Error al insertar asiento tipo '
                || r_plantilla_contable_det.POSICION ||', no se encontro cuenta contable' );        
        
        END IF;
        
    END LOOP;  
           
    msg_ret:='OK'; 
    CLOSE c_admi_plantilla_contab_det;

    EXCEPTION 
        WHEN OTHERS THEN
            msg_ret:=msg_ret||' : '|| DBMS_UTILITY.FORMAT_ERROR_STACK;
            DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNKG_CONTABILIZAR_CRUCEANT', 
                'CREA_DEBITO_CREDITO',msg_ret);
            rollback;
END CREA_DEBITO_CREDITO;


END FNKG_CONTABILIZAR_CRUCEANT;
/
