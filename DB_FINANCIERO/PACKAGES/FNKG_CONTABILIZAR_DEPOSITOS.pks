CREATE OR REPLACE PACKAGE DB_FINANCIERO.FNKG_CONTABILIZAR_DEPOSITOS
AS

  /*Documentacion para type
   *Detalles de pago para poder obtener de aqui datos para insertar en tablas del naf
   */
  Type TypeDeposito IS RECORD(
      ID_DEPOSITO               DB_FINANCIERO.INFO_DEPOSITO.ID_DEPOSITO%TYPE,
      BANCO_NAF_ID              DB_FINANCIERO.INFO_DEPOSITO.BANCO_NAF_ID%TYPE,
      NO_CUENTA_BANCO_NAF       DB_FINANCIERO.INFO_DEPOSITO.NO_CUENTA_BANCO_NAF%TYPE,
      NO_CUENTA_CONTABLE_NAF    DB_FINANCIERO.INFO_DEPOSITO.NO_CUENTA_CONTABLE_NAF%TYPE,
      NO_COMPROBANTE_DEPOSITO   DB_FINANCIERO.INFO_DEPOSITO.NO_COMPROBANTE_DEPOSITO%TYPE,
      VALOR                     DB_FINANCIERO.INFO_DEPOSITO.VALOR%TYPE,
      FE_DEPOSITO               DB_FINANCIERO.INFO_DEPOSITO.FE_DEPOSITO%TYPE,
      FE_ANULADO                DB_FINANCIERO.INFO_DEPOSITO.FE_ANULADO%TYPE,
      FE_PROCESADO              DB_FINANCIERO.INFO_DEPOSITO.FE_PROCESADO%TYPE,
      FE_CREACION               DB_FINANCIERO.INFO_DEPOSITO.FE_CREACION%TYPE,
      FE_ULT_MOD                DB_FINANCIERO.INFO_DEPOSITO.FE_ULT_MOD%TYPE,
      USR_CREACION              DB_FINANCIERO.INFO_DEPOSITO.USR_CREACION%TYPE,
      USR_PROCESA               DB_FINANCIERO.INFO_DEPOSITO.USR_PROCESA%TYPE,
      USR_ANULA                 DB_FINANCIERO.INFO_DEPOSITO.USR_ANULA%TYPE,
      USR_ULT_MOD               DB_FINANCIERO.INFO_DEPOSITO.USR_ULT_MOD%TYPE,
      ESTADO                    DB_FINANCIERO.INFO_DEPOSITO.ESTADO%TYPE,
      IP_CREACION               DB_FINANCIERO.INFO_DEPOSITO.IP_CREACION%TYPE,
      EMPRESA_ID                DB_FINANCIERO.INFO_DEPOSITO.EMPRESA_ID%TYPE,
      NUM_DEPOSITO_MIGRACION    DB_FINANCIERO.INFO_DEPOSITO.NUM_DEPOSITO_MIGRACION%TYPE,
      CUENTA_CONTABLE_ID        DB_FINANCIERO.INFO_DEPOSITO.CUENTA_CONTABLE_ID%TYPE,
      NOMBRE_OFICINA            DB_COMERCIAL.INFO_OFICINA_GRUPO.NOMBRE_OFICINA%TYPE
  );


  Type TypeOficina IS RECORD(
      ID_OFICINA      DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
      PREFIJO         DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
      NOMBRE_OFICINA  DB_COMERCIAL.INFO_OFICINA_GRUPO.NOMBRE_OFICINA%TYPE
  );


  type tb_pagos is table of DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.TypePagosDebito index by pls_integer;
--
--
/*
* Documentaci�n para FUNCION 'PROCESAR_DEPOSITO'.
* PROCEDIMIENTO QUE CREA ASIENTOS CONTABLES PARA LOS DEPOSITOS
* @author Andres Montero amontero@telconet.ec
* @version 1.0
* @since 17/03/2016
*
* @author Edson Franco <efranco@telconet.ec>
* @version 1.1 17-03-2017 - Se quita la funci�n SUBSTR de las columnas 'l_migra_arckmm.NO_FISICO' y 'l_migra_arckmm.SERIE_FISICO' para que el valor
*                           ingresado por el usuario se pase en su totalidad y se pueda realizar la comparaci�n de lo guardado en TELCOS+ con lo
*                           migrado al NAF por el n�mero de comprobante de dep�sito.
*
* @author Edson Franco <efranco@telconet.ec>
* @version 1.2 14-09-2017 - Se agrega la funci�n 'NAF47_TNET.GEK_MIGRACION.P_PROCESA_MIGRA_DOC_ASOCIADO' el cual guarda la relaci�n del detalle del
*                           pago migrado con las tablas del NAF.
*                           Se agregan la funcion implementada en NAF 'NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKMM' para insertar en la tabla
*                          'MIIGRA_ARCKMM'.
*
*
* @author Luis Lindao <llindao@telconet.ec>
* @version 1.3 06-02-2018 - Se cambia el proceso para que se contabilice en base a los montos de los pagos asociados y no por el valor registrado en 
*                           la cabecera de dep�sito.
*
* @Param in  varchar2  v_no_cia (id de la empresa)
* @Param in  number    v_deposito_id (id del deposito)
* @Param in  varchar2  v_tipo_doc (tipo documento)
* @Param in  number    v_oficina_id (id oficina)
* @Param out msg_ret   msg_ret (mensaje que retorna al finalizar proceso o cuando se produza un error)
*/
PROCEDURE procesar_deposito(v_no_cia in varchar2,v_deposito_id in number, v_oficina_id in number,msg_ret out varchar2);
--
--
/*
* Documentaci�n para FUNCION 'CREA_DEBITO_CREDITO_DEPOSITO'.
* PROCEDIMIENTO QUE CREA EL DEBITO Y CREDITO DEL ASIENTO CONTABLE
* @author Andres Montero amontero@telconet.ec
* @version 1.0
* @since 17/03/2016
* @author Edson Franco <efranco@telconet.ec>
* @version 1.1 14-08-2017 - Se agregan la funcion implementada en NAF 'NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKML' para insertar en la tabla
*                          'MIIGRA_ARCKML'.
* @Param in  NKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableCab r_plantilla_contable_cab (type de cabecera plantilla)
* @Param in  FNKG_TRANSACTION_CONTABILIZAR.TypeDeposito    lr_deposito (type para el deposito)
* @Param in  varchar2    v_tipo_doc (tipo de documento para el asiento)
* @Param out msg_ret   msg_ret (mensaje que retorna al finalizar proceso o cuando se produza un error)
*/
PROCEDURE CREA_DEBITO_CREDITO_DEPOSITO(r_plantilla_contable_cab in DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableCab,
    lr_deposito in DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.TypeDeposito,
    pt_migra_arckmm IN NAF47_TNET.MIGRA_ARCKMM%ROWTYPE,
    v_tipo_doc varchar2,
    msg_ret out varchar2, Pn_IdMigracion18 naf47_tnet.migra_arckmm.id_migracion%type);

PROCEDURE MARCA_CONTABILIZADO_PAGOS_DEP(p_deposito_id IN number);

FUNCTION GET_TIPO_DOC(p_deposito_id NUMBER) RETURN VARCHAR2;

END FNKG_CONTABILIZAR_DEPOSITOS;
/

CREATE OR REPLACE PACKAGE BODY DB_FINANCIERO.FNKG_CONTABILIZAR_DEPOSITOS
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
 
/*
* Documentaci�n para FUNCION 'GET_TIPO_DOC'.
* FUNCION QUE VERIFICA SI EL DEPOSITO TIENE TRANSFERENCIAS
* @author Andres Montero amontero@telconet.ec
* @version 1.0
* @since 25/05/2016
* @Param number p_deposito_id (ID DEL DEPOSITO)
* @return  VARCHAR2 (TIPO DOC DP O NC)
*/
FUNCTION GET_TIPO_DOC(p_deposito_id NUMBER)
  RETURN VARCHAR2
IS
    tipo_doc varchar2(5)     := 'DP';
    v_forma_pago varchar2(5) := '';
    v_total_pagos number     := 0;
    CURSOR c_pagos_det
    IS
    SELECT fp.codigo_forma_pago,count(*)
    FROM
     DB_FINANCIERO.INFO_PAGO_DET pdet
    JOIN DB_FINANCIERO.ADMI_FORMA_PAGO fp ON pdet.forma_pago_id=fp.id_forma_pago
    WHERE
    pdet.deposito_pago_id=p_deposito_id
GROUP BY fp.codigo_forma_pago;

BEGIN
    OPEN c_pagos_det;
    loop
        FETCH c_pagos_det INTO v_forma_pago,v_total_pagos;
        EXIT WHEN c_pagos_det%NOTFOUND;
        IF v_forma_pago = 'TRNG' OR v_forma_pago = 'TGMA' THEN
            tipo_doc:='NC';
        END IF;
    end loop;
    RETURN tipo_doc;
END;

/*
* Documentaci�n para PROCEDIMIENTO 'MARCA_CONTABILIZADO_PAGOS_DEP'.
* PROCEDIMIENTO QUE MARCA COMO CONTABILIZADO AL DEPOSITO
* @author Andres Montero amontero@telconet.ec
* @version 1.0
* @since 06/04/2016
* @Param in  number p_deposito_id (id del deposito)
*/
PROCEDURE MARCA_CONTABILIZADO_PAGOS_DEP(p_deposito_id IN number)
IS
BEGIN
    UPDATE DB_FINANCIERO.INFO_DEPOSITO SET CONTABILIZADO='S' WHERE ID_DEPOSITO = p_deposito_id ;
END MARCA_CONTABILIZADO_PAGOS_DEP;
--
--
PROCEDURE CREA_DEBITO_CREDITO_DEPOSITO(r_plantilla_contable_cab in DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableCab,
    lr_deposito in DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.TypeDeposito,
    pt_migra_arckmm IN NAF47_TNET.MIGRA_ARCKMM%ROWTYPE,
    v_tipo_doc varchar2,
    msg_ret out varchar2, Pn_IdMigracion18 naf47_tnet.migra_arckmm.id_migracion%type)
IS
    c_admi_plantilla_contab_det SYS_REFCURSOR ;

    r_cuenta_contable DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.TypeCuentaContable;
    r_cuenta_contable_por_tipo DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.TypeCuentaContablePorTipo;
    r_plantilla_contable_det DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableDet;

    l_migra_arckml NAF47_TNET.MIGRA_ARCKML%ROWTYPE;
    l_migra_arcgal NAF47_TNET.MIGRA_ARCGAL%ROWTYPE;

    l_MsnError        varchar2(1000);
    l_no_linea        number;
    l_no_cta_contable varchar2(16);
    l_anio            varchar2(4);
    l_mes             varchar2(2);

    ex_insert_arcgal EXCEPTION;
    PRAGMA EXCEPTION_INIT( ex_insert_arcgal, -20007 );

    ex_insert_arckml EXCEPTION;
    PRAGMA EXCEPTION_INIT( ex_insert_arckml, -20008 );

    ex_no_existe_cuenta EXCEPTION;
    PRAGMA EXCEPTION_INIT( ex_no_existe_cuenta, -20009 );
    
    Lv_EmpresaOrigen db_general.admi_parametro_det.valor2%type;
    Lv_EmpresaDestino db_general.admi_parametro_det.valor2%type;
    Lv_BanderaReplicar db_general.admi_parametro_det.valor2%type;

BEGIN
  
    Lv_EmpresaOrigen := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'EMPRESA_ORIGEN');
    Lv_EmpresaDestino := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'EMPRESA_DESTINO');
    Lv_BanderaReplicar := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'APLICA_REPLICA_MIGRACION');

    DBMS_OUTPUT.PUT_LINE('ingresando detalles');
    l_no_linea:=0;
    --OBTIENE ANIO Y MES DE LA FECHA DE DOCUMENTO
    l_anio:= TO_CHAR(lr_deposito.FE_CREACION,'YYYY');
    msg_ret:='1510';

    l_mes := TO_CHAR(lr_deposito.FE_CREACION,'MM');
    msg_ret:='1520';

    --RECORRE LOS DETALLES DE LA PLANTILLA
    --###################################
    c_admi_plantilla_contab_det:=DB_FINANCIERO.FNKG_CONTABILIZAR_PAGO_MANUAL.GET_PLANTILLA_CONTABLE_DET(r_plantilla_contable_cab.ID_PLANTILLA_CONTABLE_CAB);

    msg_ret := '6010';

    LOOP

    FETCH c_admi_plantilla_contab_det INTO r_plantilla_contable_det;

    EXIT WHEN c_admi_plantilla_contab_det%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('posicion:'||r_plantilla_contable_det.POSICION);


        --OBTIENE LA CUENTA CONTABLE
        IF r_plantilla_contable_det.TIPO_CUENTA_CONTABLE = 'BANCOS' THEN
            msg_ret:='1540';
            r_cuenta_contable:=DB_FINANCIERO.FNKG_CONTABILIZAR_PAGO_MANUAL.GET_CUENTA_CONTABLE(lr_deposito.CUENTA_CONTABLE_ID);
            l_no_cta_contable:= r_cuenta_contable.CUENTA;
        ELSE
            msg_ret:='1550';
            r_cuenta_contable_por_tipo := DB_FINANCIERO.FNKG_CONTABILIZAR_PAGO_MANUAL.GET_CUENTA_CONTABLE_POR_TIPO(lr_deposito.OFICINA_ID,
                'ID_OFICINA',r_plantilla_contable_det.TIPO_CUENTA_CONTABLE_ID,lr_deposito.EMPRESA_ID);
            l_no_cta_contable          := r_cuenta_contable_por_tipo.CUENTA;
        END IF;

        l_migra_arckml .MIGRACION_ID   := pt_migra_arckmm.ID_MIGRACION;
        l_migra_arckml.COD_DIARIO     := pt_migra_arckmm.COD_DIARIO;
        l_migra_arckml.NO_CIA         := lr_deposito.EMPRESA_ID;
        l_migra_arckml.PROCEDENCIA    := 'C';
        l_migra_arckml.TIPO_DOC       := v_tipo_doc;
        l_migra_arckml.NO_DOCU        := '05'||lr_deposito.ID_DEPOSITO;
        l_migra_arckml.COD_CONT       := l_no_cta_contable;
        l_migra_arckml.CENTRO_COSTO   := '000000000';
        l_migra_arckml.TIPO_MOV       := r_plantilla_contable_det.POSICION;
        l_migra_arckml.MONTO          := lr_deposito.VALOR;
        l_migra_arckml.MONTO_DOl      := lr_deposito.VALOR;
        l_migra_arckml.TIPO_CAMBIO    := 1;
        l_migra_arckml.MONEDA         := 'P';
        l_migra_arckml.MODIFICABLE    := 'N';
        l_migra_arckml.ANO            := l_anio;
        l_migra_arckml.MES            := l_mes;
        l_migra_arckml.MONTO_DC       := lr_deposito.VALOR;
        l_migra_arckml.GLOSA          := DB_FINANCIERO.FNKG_CONTABILIZAR_PAGO_MANUAL.GENERA_COMENTARIO(null, null, r_plantilla_contable_det.FORMATO_GLOSA,lr_deposito,null);

        --INSERTA DEBITO DEL ASIENTO
        ----------------------------
        NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKML(l_migra_arckml,l_MsnError);

        IF l_MsnError IS NOT NULL THEN
          --
          raise_application_error( -20004, 'Error al insertar asiento ('||r_plantilla_contable_det.POSICION||') en MIGRA_ARCKML.'||l_MsnError );
          --
        END IF;
        
        if nvl(Lv_BanderaReplicar,'N') = 'S' AND lr_deposito.EMPRESA_ID = Lv_EmpresaOrigen then
          l_migra_arckml.MIGRACION_ID   := Pn_IdMigracion18;
          l_migra_arckml.NO_CIA         := Lv_EmpresaDestino;
          
          NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKML(l_migra_arckml,l_MsnError);

          IF l_MsnError IS NOT NULL THEN
          --
             raise_application_error( -20004, 'Error al insertar asiento ('||r_plantilla_contable_det.POSICION||') en MIGRA_ARCKML.'||l_MsnError );
          --
          END IF;
          
          l_migra_arckml.MIGRACION_ID   := pt_migra_arckmm.ID_MIGRACION;
          l_migra_arckml.NO_CIA         := lr_deposito.EMPRESA_ID;
        end if;

        msg_ret := '7000';

        DBMS_OUTPUT.PUT_LINE('cta contable:'||l_no_cta_contable);
    END LOOP;
    --
    msg_ret := '8000';
    --
    CLOSE c_admi_plantilla_contab_det;
    --
    msg_ret:='Proceso OK';
    --
  EXCEPTION

        WHEN ex_insert_arckml THEN
            msg_ret:=msg_ret||' : '|| DBMS_UTILITY.FORMAT_ERROR_STACK;
            rollback;
        WHEN OTHERS THEN
            msg_ret:=msg_ret||' : '|| DBMS_UTILITY.FORMAT_ERROR_STACK;
            DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNKG_CONTABILIZAR',
                'PROCESAR_PAGO_ANTICIPO_MANUAL',msg_ret);
            rollback;
END CREA_DEBITO_CREDITO_DEPOSITO;
--
--
PROCEDURE PROCESAR_DEPOSITO(v_no_cia in varchar2,v_deposito_id in number, v_oficina_id in number,msg_ret out varchar2)
IS
    lr_deposito DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.TypeDeposito;
    lr_oficina DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.TypeOficina;

    c_admi_plantilla_contab_det SYS_REFCURSOR ;

    r_plantilla_contable_cab DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableCab;
    r_plantilla_contable_det DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableDet;
    r_cuenta_contable DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.TypeCuentaContable;

    l_migra_arckmm NAF47_TNET.MIGRA_ARCKMM%ROWTYPE;
    l_migra_arckml NAF47_TNET.MIGRA_ARCKML%ROWTYPE;

    l_MsnError           varchar2(1000);
    l_msn_debito_credito varchar2(1000);

    l_anio             varchar2(4);
    l_mes              varchar2(2);
    l_no_cta           varchar2(16) :='';
    l_tipo_doc         varchar2(5);

    ex_insert_arckmm EXCEPTION;
    PRAGMA EXCEPTION_INIT( ex_insert_arckmm, -20003 );

    ex_insert_arckml EXCEPTION;
    PRAGMA EXCEPTION_INIT( ex_insert_arckml, -20004 );
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
      and mda.no_cia = Cv_EmpresaCod;
      --
    --
    --CURSOR PARA OBTENER LOS PAGOS ASOCIADOS A UN DEPOSITO
    --COSTO QUERY: 12
    CURSOR C_GetPagosDeposito( Cn_DepositoId       DB_FINANCIERO.INFO_DEPOSITO.ID_DEPOSITO%TYPE,
                               Cv_NombrePaqueteSQL VARCHAR2,
                               Cv_EstadoActivo     VARCHAR2)
    IS
      --
      SELECT IPD.FORMA_PAGO_ID,
        IPD.ID_PAGO_DET,
        IPC.TIPO_DOCUMENTO_ID,
        IPD.ESTADO,
        IPD.VALOR_PAGO
      FROM DB_FINANCIERO.INFO_PAGO_DET IPD
      JOIN DB_FINANCIERO.INFO_PAGO_CAB IPC
      ON IPD.PAGO_ID             = IPC.ID_PAGO
      WHERE IPD.DEPOSITO_PAGO_ID = Cn_DepositoId
      AND IPC.ANTICIPO_ID IS NULL
      AND NOT EXISTS (SELECT NULL
                FROM NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO MDA
                WHERE MDA.DOCUMENTO_ORIGEN_ID = IPD.ID_PAGO_DET
                AND EXISTS (SELECT NULL
                            FROM DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB APCC
                            WHERE APCC.COD_DIARIO = MDA.TIPO_DOC_MIGRACION
                            AND APCC.EMPRESA_COD        = MDA.NO_CIA
                            AND APCC.NOMBRE_PAQUETE_SQL = Cv_NombrePaqueteSQL
                            AND APCC.ESTADO             = Cv_EstadoActivo));
    --
    --CURSOR QUE RETORNA LOS DEPOSITOS A PROCESAR
    CURSOR C_GetDepositos( Cn_DepositoId DB_FINANCIERO.INFO_DEPOSITO.ID_DEPOSITO%TYPE,
                           Cv_EstadoActivo DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.ESTADO%TYPE,
                           Cv_NombrePaqueteSQL DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.NOMBRE_PAQUETE_SQL%TYPE )
    IS
      --
      SELECT IDEP.ID_DEPOSITO,
        IDEP.BANCO_NAF_ID,
        IDEP.NO_CUENTA_BANCO_NAF,
        IDEP.NO_CUENTA_CONTABLE_NAF,
        IDEP.NO_COMPROBANTE_DEPOSITO,
        SUM(IPD.VALOR_PAGO) VALOR,
        IDEP.FE_DEPOSITO,
        IDEP.FE_ANULADO,
        IDEP.FE_PROCESADO,
        IDEP.FE_CREACION,
        IDEP.FE_ULT_MOD,
        IDEP.USR_CREACION,
        IDEP.USR_PROCESA,
        IDEP.USR_ANULA,
        IDEP.USR_ULT_MOD,
        IDEP.ESTADO,
        IDEP.IP_CREACION,
        IDEP.EMPRESA_ID,
        IDEP.NUM_DEPOSITO_MIGRACION,
        IDEP.CUENTA_CONTABLE_ID,
        0 OFICINA_ID,
        NULL NOMBRE_OFICINA
      FROM DB_FINANCIERO.INFO_DEPOSITO IDEP
      JOIN DB_FINANCIERO.INFO_PAGO_DET IPD ON IPD.DEPOSITO_PAGO_ID = IDEP.ID_DEPOSITO
      JOIN DB_FINANCIERO.INFO_PAGO_CAB IPC ON IPC.ID_PAGO = IPD.PAGO_ID
      WHERE IDEP.ID_DEPOSITO         = Cn_DepositoId
      AND IPC.ANTICIPO_ID IS NULL
      AND NOT EXISTS (SELECT NULL
                      FROM NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO MDA
                      WHERE MDA.DOCUMENTO_ORIGEN_ID = IPD.ID_PAGO_DET
                      AND EXISTS (SELECT NULL
                                  FROM DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB APCC
                                  WHERE APCC.COD_DIARIO = MDA.TIPO_DOC_MIGRACION
                                  AND APCC.EMPRESA_COD        = MDA.NO_CIA
                                  AND APCC.NOMBRE_PAQUETE_SQL = Cv_NombrePaqueteSQL
                                  AND APCC.ESTADO             = Cv_EstadoActivo))
      GROUP BY IDEP.ID_DEPOSITO,
        IDEP.BANCO_NAF_ID,
        IDEP.NO_CUENTA_BANCO_NAF,
        IDEP.NO_CUENTA_CONTABLE_NAF,
        IDEP.NO_COMPROBANTE_DEPOSITO,
        IDEP.FE_DEPOSITO,
        IDEP.FE_ANULADO,
        IDEP.FE_PROCESADO,
        IDEP.FE_CREACION,
        IDEP.FE_ULT_MOD,
        IDEP.USR_CREACION,
        IDEP.USR_PROCESA,
        IDEP.USR_ANULA,
        IDEP.USR_ULT_MOD,
        IDEP.ESTADO,
        IDEP.IP_CREACION,
        IDEP.EMPRESA_ID,
        IDEP.NUM_DEPOSITO_MIGRACION,
        IDEP.CUENTA_CONTABLE_ID
      HAVING SUM(IPD.VALOR_PAGO) > 0;
      --
    --
    CURSOR c_oficina
    IS
    SELECT
      ofi.id_oficina, emp.PREFIJO, ofi.NOMBRE_OFICINA
    FROM
        DB_COMERCIAL.INFO_OFICINA_GRUPO ofi JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO emp ON ofi.empresa_id=emp.cod_empresa
    WHERE
        ofi.ID_OFICINA=v_oficina_id;
  --
  Lv_NombrePaqueteSQL DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.NOMBRE_PAQUETE_SQL%TYPE := 'FNKG_CONTABILIZAR_DEPOSITOS';
  Lv_EstadoActivo DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE                             := 'Activo';
  Lv_EstadoAnulado DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE                            := 'Anulado';
  --
  Le_MigraDocumentoAsociado EXCEPTION;
  PRAGMA EXCEPTION_INIT( Le_MigraDocumentoAsociado, -20001 );
  --
  Lr_MigraDocumentoAsociado NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO%ROWTYPE;
  Lr_GetValidaPagoMigrado C_GetValidaPagoMigrado%ROWTYPE;
  Lr_GetPagosDeposito C_GetPagosDeposito%ROWTYPE;
  --
  
  Ln_IdMigracion33 naf47_tnet.migra_arckmm.id_migracion%type;
  Ln_IdMigracion18 naf47_tnet.migra_arckmm.id_migracion%type;
  
  Lv_EmpresaOrigen db_general.admi_parametro_det.valor2%type;
    Lv_EmpresaDestino db_general.admi_parametro_det.valor2%type;
    Lv_BanderaReplicar db_general.admi_parametro_det.valor2%type;
    
BEGIN
    Lv_EmpresaOrigen := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'EMPRESA_ORIGEN');
      Lv_EmpresaDestino := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'EMPRESA_DESTINO');
      Lv_BanderaReplicar := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'APLICA_REPLICA_MIGRACION');
    --SE REGISTRAN LOS SIGUIENTES PARAMETROS EN LA TABLA INFO_ERROR dnatha 29/10/2019
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'LOG DE EJECUCION DE PAGOS',
                                          'Ejecucion del proceso FNKG_CONTABILIZAR_DEPOSITOS.PROCESAR_DEPOSITO con los sgtes parametros... Codigo de empresa:' || v_no_cia || ', depositoId: ' || v_deposito_id || ', oficinaId: ' || v_oficina_id,
                                          'telcos',
                                          SYSDATE,    
                                          '172.0.0.1');

    --
    msg_ret := '1000';

    l_tipo_doc := GET_TIPO_DOC(v_deposito_id);
    --
    --RECORRE LOS DATOS DEL DETALLE DE PAGO
    msg_ret := '2000';
    --
    FOR lr_deposito IN C_GetDepositos ( v_deposito_id,
                                        Lv_EstadoActivo,
                                        Lv_NombrePaqueteSQL ) LOOP

      dbms_output.put_line('valorDeposito:'||lr_deposito.VALOR);

      OPEN c_oficina;
      FETCH c_oficina INTO lr_oficina;

      msg_ret := '3000';

      --OBTIENE ANIO Y MES DE LA FECHA DE DOCUMENTO
      l_anio:= TO_CHAR(lr_deposito.FE_CREACION,'YYYY');
      l_mes := TO_CHAR(lr_deposito.FE_CREACION,'MM');
      msg_ret := '4000';
      --
      lr_deposito.OFICINA_ID     := lr_oficina.ID_OFICINA;
      lr_deposito.NOMBRE_OFICINA := lr_oficina.NOMBRE_OFICINA;

      --CABECERA DEL ASIENTO
      --#####################

      r_plantilla_contable_cab := DB_FINANCIERO.FNKG_CONTABILIZAR_PAGO_MANUAL.GET_PLANTILLA_CONTABLE_CAB_COD(v_no_cia, 'DEP', 'PAG', 'MASIVO');

      --NUMERO CUENTA DEL BANCO
      r_cuenta_contable:= DB_FINANCIERO.FNKG_CONTABILIZAR_PAGO_MANUAL.GET_CUENTA_CONTABLE(lr_deposito.CUENTA_CONTABLE_ID);
      l_no_cta         := r_cuenta_contable.NO_CTA;
      --
      l_migra_arckmm .ID_FORMA_PAGO          := r_plantilla_contable_cab .ID_FORMA_PAGO;
      l_migra_arckmm.ID_OFICINA_FACTURACION := lr_deposito.OFICINA_ID;
      --
      IF nvl(Lv_BanderaReplicar,'N') = 'S' AND V_NO_CIA = Lv_EmpresaOrigen THEN
        l_migra_arckmm.ID_MIGRACION    := NAF47_TNET.TRANSA_ID.MIGRA_CK ( Lv_EmpresaOrigen );
        Ln_IdMigracion33 := l_migra_arckmm.ID_MIGRACION;
        Ln_IdMigracion18 := NAF47_TNET.TRANSA_ID.MIGRA_CK ( Lv_EmpresaDestino );
      ELSE
        l_migra_arckmm.ID_MIGRACION    := NAF47_TNET.TRANSA_ID.MIGRA_CK ( v_no_cia );
      END IF;
      
      l_migra_arckmm.COD_DIARIO      := r_plantilla_contable_cab.COD_DIARIO;
      l_migra_arckmm.NO_CIA          := v_no_cia;
      l_migra_arckmm.NO_CTA          := l_no_cta;
      l_migra_arckmm.PROCEDENCIA     := 'C';
      l_migra_arckmm.TIPO_DOC        := l_tipo_doc;
      l_migra_arckmm.NO_DOCU         := '05'||lr_deposito.ID_DEPOSITO;
      l_migra_arckmm.FECHA           := lr_deposito.FE_CREACION;
      l_migra_arckmm.COMENTARIO      := DB_FINANCIERO.FNKG_CONTABILIZAR_PAGO_MANUAL.GENERA_COMENTARIO( null,
                                                                                                       null,
                                                                                                       r_plantilla_contable_cab.FORMATO_GLOSA,
                                                                                                       lr_deposito,
                                                                                                       null );
      l_migra_arckmm.MONTO           := lr_deposito.VALOR;
      l_migra_arckmm.ESTADO          := 'P';
      l_migra_arckmm.CONCILIADO      := 'N';
      l_migra_arckmm.MES             := TO_NUMBER(l_mes);
      l_migra_arckmm.ANO             := TO_NUMBER(l_anio);
      l_migra_arckmm.IND_OTROMOV     := 'S';
      l_migra_arckmm.MONEDA_CTA      := 'P';
      l_migra_arckmm.TIPO_CAMBIO     := '1';
      l_migra_arckmm.T_CAMB_C_V      := 'C';
      l_migra_arckmm.IND_OTROS_MESES := 'N';
      l_migra_arckmm.NO_FISICO       := lr_deposito.NO_COMPROBANTE_DEPOSITO;
      l_migra_arckmm.SERIE_FISICO    := lr_deposito.NO_COMPROBANTE_DEPOSITO;
      l_migra_arckmm.ORIGEN          := lr_oficina.PREFIJO;
      l_migra_arckmm.USUARIO_CREACION:= lr_deposito.USR_CREACION;
      l_migra_arckmm.FECHA_DOC       := lr_deposito.FE_CREACION;
      l_migra_arckmm.IND_DIVISION    := 'N';
      l_migra_arckmm.FECHA_CREACION  := sysdate;
      --
      l_MsnError := NULL;
      --
      DBMS_OUTPUT.PUT_LINE('NO_DOCU:'||l_migra_arckmm.NO_DOCU ||' TIPO_DOC:'||l_migra_arckmm.TIPO_DOC||' COMENTARIO:'||l_migra_arckmm.COMENTARIO);
      --INSERTA CABECERA DEL ASIENTO
      ----------------------------
      NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKMM(l_migra_arckmm, l_MsnError);
      --
      --
      IF l_MsnError IS NOT NULL THEN
        --
        raise_application_error( -20003, 'Error al insertar cabecera asiento en MIGRA_ARCKMM. '||l_MsnError  );
        --
      END IF;
      --
      IF nvl(Lv_BanderaReplicar,'N') = 'S' AND V_NO_CIA = Lv_EmpresaOrigen THEN
        DECLARE
         Ln_IdOficina DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%type;
        BEGIN
          select id_oficina INTO Ln_IdOficina
                      from DB_COMERCIAL.INFO_OFICINA_GRUPO b
                     where b.NOMBRE_OFICINA = (select replace(A.NOMBRE_OFICINA, 'ECUANET', 'MEGADATOS')
                                                 from DB_COMERCIAL.INFO_OFICINA_GRUPO a
                                                where a.id_oficina = lr_deposito.OFICINA_ID);
          
          l_migra_arckmm.ID_OFICINA_FACTURACION := Ln_IdOficina;
          l_migra_arckmm.ID_MIGRACION := Ln_IdMigracion18;
          l_migra_arckmm.NO_CIA := Lv_EmpresaDestino;
          
          NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKMM(l_migra_arckmm, l_MsnError);
          
          IF l_MsnError IS NOT NULL THEN
             raise_application_error( -20003, 'Error al insertar cabecera asiento en MIGRA_ARCKMM. '||l_MsnError  );
          END IF;
          
          l_migra_arckmm.ID_OFICINA_FACTURACION := lr_deposito.OFICINA_ID;
          l_migra_arckmm.ID_MIGRACION := Ln_IdMigracion33;
          l_migra_arckmm.NO_CIA := V_NO_CIA;
                                                          
        END;
      END IF;
      --
      FOR Lr_GetPagosDeposito IN C_GetPagosDeposito ( lr_deposito.ID_DEPOSITO,
                                                      Lv_EstadoActivo,
                                                      Lv_NombrePaqueteSQL ) LOOP
          --
          Lr_MigraDocumentoAsociado                     := NULL;
          Lr_MigraDocumentoAsociado.DOCUMENTO_ORIGEN_ID := Lr_GetPagosDeposito.ID_PAGO_DET;
          Lr_MigraDocumentoAsociado.TIPO_DOC_MIGRACION  := r_plantilla_contable_cab.COD_DIARIO;
          Lr_MigraDocumentoAsociado.NO_CIA              := v_no_cia;
          Lr_MigraDocumentoAsociado.FORMA_PAGO_ID       := r_plantilla_contable_cab.ID_FORMA_PAGO;
          Lr_MigraDocumentoAsociado.TIPO_DOCUMENTO_ID   := Lr_GetPagosDeposito.TIPO_DOCUMENTO_ID;
          Lr_MigraDocumentoAsociado.ESTADO              := 'M';
          Lr_MigraDocumentoAsociado.USR_CREACION        := lr_deposito.USR_CREACION;
          Lr_MigraDocumentoAsociado.FE_CREACION         := SYSDATE;
          Lr_MigraDocumentoAsociado.MIGRACION_ID        := l_migra_arckmm.ID_MIGRACION;
          Lr_MigraDocumentoAsociado.TIPO_MIGRACION      := 'CK';
          --
          --
          IF Lr_MigraDocumentoAsociado.MIGRACION_ID IS NOT NULL AND Lr_MigraDocumentoAsociado.MIGRACION_ID > 0 THEN
            --
            msg_ret := NULL;
            --
            NAF47_TNET.GEK_MIGRACION.P_PROCESA_MIGRA_DOC_ASOCIADO(Lr_MigraDocumentoAsociado, 'I', msg_ret);
            --
            IF msg_ret IS NOT NULL THEN
              --
              raise_application_error( -20001, 'Error al insertar la relaci�n del documento migrado en la tabla MIGRA_DOCUMENTO_ASOCIADO. ' ||
                                               ' DETALLE_PAGO ( ' || Lr_GetPagosDeposito.ID_PAGO_DET || '). MENSAJE ERROR NAF (' || msg_ret || ').');
              --
            END IF;
            --
            
            IF nvl(Lv_BanderaReplicar,'N') = 'S' AND V_NO_CIA = Lv_EmpresaOrigen THEN
              Lr_MigraDocumentoAsociado.NO_CIA := Lv_EmpresaDestino;
              Lr_MigraDocumentoAsociado.MIGRACION_ID := Ln_IdMigracion18;
              
              NAF47_TNET.GEK_MIGRACION.P_PROCESA_MIGRA_DOC_ASOCIADO(Lr_MigraDocumentoAsociado, 'I', msg_ret);
              
              IF msg_ret IS NOT NULL THEN
              raise_application_error( -20001, 'Error al insertar la relaci�n del documento migrado en la tabla MIGRA_DOCUMENTO_ASOCIADO. ' ||
                                               ' DETALLE_PAGO ( ' || Lr_GetPagosDeposito.ID_PAGO_DET || '). MENSAJE ERROR NAF (' || msg_ret || ').');
              --
            END IF;
              
              Lr_MigraDocumentoAsociado.NO_CIA := V_NO_CIA;
              Lr_MigraDocumentoAsociado.MIGRACION_ID := l_migra_arckmm.ID_MIGRACION;
            END IF;
          ELSE
            --
            raise_application_error( -20001, 'Error al insertar la relaci�n del documento migrado en la tabla MIGRA_DOCUMENTO_ASOCIADO. ' ||
                                             ' DETALLE_PAGO ( ' || Lr_GetPagosDeposito.ID_PAGO_DET || '). MENSAJE ERROR ( NO EXISTE ID_MIGRACION ).');
            --
          END IF;
          --
          --
        --END IF;
        --
      END LOOP;
      --
      --DETALLE DEL ASIENTO
      --#####################
      
      CREA_DEBITO_CREDITO_DEPOSITO(r_plantilla_contable_cab, lr_deposito, l_migra_arckmm, l_tipo_doc, 
      l_msn_debito_credito, Ln_IdMigracion18);

      IF (l_msn_debito_credito<>'Proceso OK') THEN

          raise_application_error( -20004, ' '||l_msn_debito_credito);
      END IF;
      --
      msg_ret := '8000';
      --
      msg_ret:='Proceso OK';
      --
      --
      MARCA_CONTABILIZADO_PAGOS_DEP(v_deposito_id);
      --
    END LOOP;
    --
    --
    COMMIT;
    --
  EXCEPTION
  WHEN ex_insert_arckmm THEN
    --
    msg_ret := msg_ret || ' : ' || DBMS_UTILITY.FORMAT_ERROR_STACK;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNKG_CONTABILIZAR_DEPOSITOS.PROCESAR_DEPOSITO',
                                          msg_ret,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
    ROLLBACK;
    --
  WHEN ex_insert_arckml THEN
    --
    msg_ret := msg_ret || ' : ' || DBMS_UTILITY.FORMAT_ERROR_STACK;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNKG_CONTABILIZAR_DEPOSITOS.PROCESAR_DEPOSITO',
                                          msg_ret,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
    ROLLBACK;
    --
  WHEN Le_MigraDocumentoAsociado THEN
    --
    msg_ret := msg_ret || ' : ' || DBMS_UTILITY.FORMAT_ERROR_STACK;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNKG_CONTABILIZAR_DEPOSITOS.PROCESAR_DEPOSITO',
                                          msg_ret,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
    ROLLBACK;
    --
  WHEN OTHERS THEN
    --
    msg_ret := msg_ret || ' : ' || DBMS_UTILITY.FORMAT_ERROR_STACK;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNKG_CONTABILIZAR_DEPOSITOS.PROCESAR_DEPOSITO',
                                          msg_ret,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
    ROLLBACK;
    --
  END PROCESAR_DEPOSITO;
  --
  --
END FNKG_CONTABILIZAR_DEPOSITOS;
/

