CREATE EDITIONABLE PACKAGE               FNKG_CONTABILIZAR_PAGO_MANUAL
AS

--
/**
* Documentacion para el PKG FNKG_CONTABILIZAR_PAGO_MANUAL
* El PKG FNKG_CONTABILIZAR_PAGO_MANUAL contendra las variables que sean necesarias a usar en los PKG de consultas o transacciones
* separando procedimientos y funciones de las declaraciones de variables.
* Genera los asientos contables para los pagos manuales creados en la aplicacion Telcos.
* @author Andres Montero <amontero@telconet.ec>
* @version 1.0 16-04-2016
*/
--


TYPE TypeArreglo IS TABLE OF VARCHAR2(2000) INDEX BY BINARY_INTEGER;


/*
* Documentaci�n para FUNCION 'CREA_DEBITO_CREDITO'.
* PROCEDIMIENTO QUE CREA EL DEBITO Y CREDITO DEL ASIENTO CONTABLE
* @author Andres Montero amontero@telconet.ec
* @version 1.0
*
* Actualizacion: Se valida que el monto sea diferente a 0 antes de grabar linea de asiento
* @author Andres Montero amontero@telconet.ec
* @version 1.1 31/08/2016
* @author Edson Franco <efranco@telconet.ec>
* @version 1.2 09-01-2017 - Se cambia la funci�n para no enviar centro de costos a los pagos por provisiones incobrables
* @author Edson Franco <efranco@telconet.ec>
* @version 1.3 08-08-2017 - Se cambia la funci�n para agregar a los detalles el nuevo campo 'MIGRACION_ID' relacionado a la tabla
*                           'NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO'.
*                           Se agregan las funciones implementadas en NAF 'NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKML' y
*                           'NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAL' para insertar en las tablas 'MIIGRA_ARCKML' y 'MIGRA_ARCGAL'
*                           respectivamente.
* @author Edson Franco <efranco@telconet.ec>
* @version 1.4 13-09-2017 - Se cambia la funci�n para validar que cuando sea 'ANT' se migre su contrapartida obtiendo el valor de MONTO_ANTICIPOS en
*                           caso que la columna 'MONTO' se igual a cero.
* @author Luis Lindao <llindao@telconet.ec>
* @version 1.5 27-11-2017 - Se agrega tipo de cuenta contable RECAUDACION_SIN_SOPORTE para recuperar cuenta contable mediante codigo de FORMA_PAGO
*
* @author Luis Lindao <llindao@telconet.ec>
* @version 1.6 11-01-2019 - Se agrega recuparar centro de costo de variable registro que retorna funcion de cuenta contable.
*
* @author Luis Lindao <llindao@telconet.ec>
* @version 1.7 23-03-2021 - Se modifica para que proceso considere documento ANTC a contabilizar.
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
    msg_ret out varchar2, Pn_IdMigracion18 NAF47_TNET.migra_arcgae.id_migracion%type default null);

FUNCTION GET_CUENTA_CONTABLE(p_cuenta_contable_id NUMBER) RETURN FNKG_TRANSACTION_CONTABILIZAR.TypeCuentaContable;

FUNCTION GET_CUENTA_CONTABLE_POR_TIPO(p_valor_campo_ref NUMBER,p_nombre_campo_ref VARCHAR2, p_id_tipo_cta_contable NUMBER, p_empresa_cod VARCHAR2) RETURN FNKG_TRANSACTION_CONTABILIZAR.TypeCuentaContablePorTipo;

FUNCTION GET_PLANTILLA_CONTABLE_CAB(p_empresa_cod VARCHAR2, p_forma_pago_id NUMBER , p_tipo_documento_id NUMBER, p_tipo_proceso VARCHAR2)  RETURN FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableCab;

FUNCTION GET_PLANTILLA_CONTABLE_CAB_COD(p_empresa_cod VARCHAR2, p_cod_forma_pago VARCHAR2 , p_cod_tipo_documento VARCHAR2,p_tipo_proceso VARCHAR2) RETURN FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableCab;

FUNCTION GET_PLANTILLA_CONTABLE_DET(p_cabecera_id NUMBER) RETURN SYS_REFCURSOR;

FUNCTION GET_PLANTILLA_CONTABLE_DET_POS(p_cabecera_id NUMBER, p_posicion VARCHAR2) RETURN SYS_REFCURSOR;

FUNCTION GENERA_COMENTARIO(lr_detalle_pago IN FNKG_TRANSACTION_CONTABILIZAR.TypeDetallePagos,
    cadena_adicional IN varchar2, p_formato IN varchar2,
    p_deposito IN FNKG_TRANSACTION_CONTABILIZAR.TypeDeposito,
    p_datos_debito IN FNKG_TRANSACTION_CONTABILIZAR.TypeDatosDebito)
  RETURN VARCHAR2;

FUNCTION GENERA_NO_DOCU_ASIENTO(p_formato in VARCHAR2, p_id IN NUMBER, pt_detalle_pago in FNKG_TRANSACTION_CONTABILIZAR.TypeDetallePagos) RETURN VARCHAR2;

PROCEDURE P_SPLIT(Pv_Cadena   IN VARCHAR2,Pv_Caracter IN VARCHAR2,Pr_Arreglo  OUT TypeArreglo);

FUNCTION OBTIENE_PREFIJO_EMPRESA (p_empresa_cod IN VARCHAR2) RETURN VARCHAR2;

PROCEDURE MARCA_CONTABILIZADO_PAGO(p_pago_det_id IN number, p_pago_id IN number, p_estado_pago IN varchar2);
  --
  --
  /**
  * Documentacion para el procedimiento PROCESAR_PAGO_ANTICIPO_MANUAL
  *
  * PROCEDIMIENTO QUE REALIZA EL PROCESO DE CREAR ASIENTOS CONTABLES PARA LOS PAGOS O ANTICIPOS MANUALES CON LAS FORMAS DE PAGO SIGUIENTES:
  *   DEPOSITOS DE MESES ANTERIORES
  *   DEPOSITOS
  *   TRANSFERENCIAS DE MESES ANTERIORES
  *   TRANSFERENCIAS
  *   TARJETA DE CREDITO
  *   DEBITO BANCARIO
  *   EFECTIVO
  *   CHEQUE
  *   DEPOSITOS GRUPALES
  *   DEPOSITOS GRUPALES MESES ANTERIORES
  *   TRANSFERENCIAS GRUPALES
  *   TRANSFERENCIAS GRUPALES MESES ANTERIORES
  *
  * @author Andres Montero amontero@telconet.ec
  * @version 1.0
  * @since 17/03/2016
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 08-12-2016 - Se cambia el procedure para validar si el detalle del pago genera o no un anticipo para que sea contabilizado como un
  *                           solo asiento contable. Para ello se crea la variable 'Pv_GeneraAnticipo' que indica 'S' cuando el detalle genero
  *                           anticipo.
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.2 17-03-2017 - Se quita la funci�n SUBSTR de las columnas 'l_no_fisico' y 'l_serie_fisico' para que el valor ingresado por el usuario
  *                           se pase en su totalidad y se pueda realizar la comparaci�n de lo guardado en TELCOS+ con lo migrado al NAF por el
  *                           n�mero de referencia.
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.3 08-08-2017 - Se agrega al query principal la validaci�n para que no retorne los pagos que ya hayan sido migrados al NAF.
  *                           Se agregan las funciones implementadas en NAF 'NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKMM' y
  *                           'NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAE' para insertar en las tablas 'MIIGRA_ARCKMM' y 'MIGRA_ARCGAE'
  *                           respectivamente.
  *                           Se agrega la funci�n 'NAF47_TNET.GEK_MIGRACION.P_PROCESA_MIGRA_DOC_ASOCIADO' el cual guarda la relaci�n del detalle del
  *                           pago migrado con las tablas del NAF.
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.4 23-03-2021 - Se agrega funcionalidad para contabilizar documentos ANTC generados por aplicaci�n de NC a FACTURA sin saldo
  *
  * @param v_no_cia           IN VARCHAR2  Variable que contiene el c�digo de la empresa que va a contabilizar
  * @param v_pago_det_id      IN NUMBER    Id del detalle a ser contabilizado. Id perteneciente a la tabla 'DB_FINANCIERO.INFO_PAGO_DET'
  * @param Pv_GeneraAnticipo  IN VARCHAR2  Variable que indica si el detalle del pago gener� un anticipo
  * @param msg_ret            OUT VARCHAR2  Variable que retorna el mensaje de ERROR o de EXITO del proceso contable realizado.
  */
  PROCEDURE PROCESAR_PAGO_ANTICIPO_MANUAL(
      v_no_cia          IN VARCHAR2,
      v_pago_det_id     IN NUMBER,
      Pv_GeneraAnticipo IN VARCHAR2,
      msg_ret           OUT VARCHAR2);
  --
  --
FUNCTION GET_ANTICIPO_ADICIONAL(p_cabecera_id NUMBER) RETURN SYS_REFCURSOR;

END FNKG_CONTABILIZAR_PAGO_MANUAL;
/

CREATE EDITIONABLE PACKAGE BODY               FNKG_CONTABILIZAR_PAGO_MANUAL
AS
  -- Variable Global para permitir contabilizaci�n por banco tipo cuenta
  Gn_BancoTipoCtaId DB_GENERAL.ADMI_BANCO_TIPO_CUENTA.ID_BANCO_TIPO_CUENTA%TYPE := NULL;
  
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

PROCEDURE CREA_DEBITO_CREDITO(
    pt_plantilla_contable_cab in FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableCab,
    pt_detalle_pago in FNKG_TRANSACTION_CONTABILIZAR.TypeDetallePagos,
    pt_migra_arckmm IN NAF47_TNET.MIGRA_ARCKMM%ROWTYPE,
    pt_migra_arcgae IN NAF47_TNET.MIGRA_ARCGAE%ROWTYPE,
    msg_ret out varchar2, 
    Pn_IdMigracion18 NAF47_TNET.migra_arcgae.id_migracion%type default null)
IS
    c_admi_plantilla_contab_det SYS_REFCURSOR ;
    c_pagos_det                 SYS_REFCURSOR ;

    r_cuenta_contable FNKG_TRANSACTION_CONTABILIZAR.TypeCuentaContable;
    r_cuenta_contable_por_tipo FNKG_TRANSACTION_CONTABILIZAR.TypeCuentaContablePorTipo;
    r_plantilla_contable_det FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableDet;
    r_detalle_anticipos FNKG_TRANSACTION_CONTABILIZAR.TypeDetallePagos;

    l_migra_arckml      NAF47_TNET.MIGRA_ARCKML%ROWTYPE;
    l_migra_arcgal      NAF47_TNET.MIGRA_ARCGAL%ROWTYPE;
    Lv_CampoReferencial DB_FINANCIERO.ADMI_CUENTA_CONTABLE.CAMPO_REFERENCIAL%TYPE := NULL;
    Lv_ValorCampoRef    DB_FINANCIERO.ADMI_CUENTA_CONTABLE.VALOR_CAMPO_REFERENCIAL%TYPE := NULL;

    l_MsnError        varchar2(500);
    l_no_linea        number;
    l_no_cta_contable varchar2(16);
    Lv_CentroCosto    varchar2(16);
    l_anio            varchar2(4);
    l_mes             varchar2(2);
    l_cc1             varchar2(3):='000';
    l_cc2             varchar2(3):='000';
    l_cc3             varchar2(3):='000';
    l_valor_tipo      number     := 1;

    ex_insert_arcgal EXCEPTION;
    PRAGMA EXCEPTION_INIT( ex_insert_arcgal, -20007 );

    ex_insert_arckml EXCEPTION;
    PRAGMA EXCEPTION_INIT( ex_insert_arckml, -20008 );

    ex_no_existe_cuenta EXCEPTION;
    PRAGMA EXCEPTION_INIT( ex_no_existe_cuenta, -20009 );

    Lrf_GetAdmiParametrosDet SYS_REFCURSOR;
    Lr_GetAdmiParametrosDet  DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
    Lb_Boolean BOOLEAN;
    --
    Lv_EmpresaOrigen db_general.admi_parametro_det.valor2%type;
    Lv_EmpresaDestino db_general.admi_parametro_det.valor2%type;
    Lv_BanderaReplicar db_general.admi_parametro_det.valor2%type;
    
BEGIN
  Lv_EmpresaOrigen := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'EMPRESA_ORIGEN');
      Lv_EmpresaDestino := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'EMPRESA_DESTINO');
      Lv_BanderaReplicar := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'APLICA_REPLICA_MIGRACION');
      
    l_no_linea:=0;
    --OBTIENE ANIO Y MES DE LA FECHA DE DOCUMENTO
    l_anio:= TO_CHAR(pt_detalle_pago.FE_CREACION,'YYYY');
    msg_ret:='1510';

    l_mes := TO_CHAR(pt_detalle_pago.FE_CREACION,'MM');
    msg_ret:='1520';
    --
    --
    --RECORRE LOS DETALLES DE LA PLANTILLA
    --###################################

    c_admi_plantilla_contab_det:=GET_PLANTILLA_CONTABLE_DET(pt_plantilla_contable_cab.ID_PLANTILLA_CONTABLE_CAB);
    LOOP

    FETCH c_admi_plantilla_contab_det INTO r_plantilla_contable_det;
    msg_ret:='1530';
    EXIT WHEN c_admi_plantilla_contab_det%NOTFOUND;

        --OBTIENE LA CUENTA CONTABLE
        IF r_plantilla_contable_det.TIPO_CUENTA_CONTABLE IN ( 'BANCOS', 'MESES_ANTERIORES') THEN
            msg_ret:='1540';
            r_cuenta_contable := GET_CUENTA_CONTABLE(pt_detalle_pago.CUENTA_CONTABLE_ID);
            l_no_cta_contable := r_cuenta_contable.CUENTA;
            Lv_CentroCosto := r_cuenta_contable.CENTRO_COSTO;
        ELSE
          IF r_plantilla_contable_det.TIPO_CUENTA_CONTABLE IN ('FORMA PAGO','RECAUDACION_SIN_SOPORTE', 'DOCUMENTO_X_COBRAR') THEN
            msg_ret:='1540';
            Lv_CampoReferencial := 'ID_FORMA_PAGO';
            Lv_ValorCampoRef    := pt_detalle_pago.ID_FORMA_PAGO;
          ELSIF r_plantilla_contable_det.TIPO_CUENTA_CONTABLE = 'BANCOS DEBITOS MD' THEN
            msg_ret:='1541';
            Lv_CampoReferencial := 'ID_BANCO_TIPO_CUENTA';
            Lv_ValorCampoRef    := Gn_BancoTipoCtaId;
          ELSE
            msg_ret:='1550';
            Lv_CampoReferencial := 'ID_OFICINA';
            Lv_ValorCampoRef    := pt_detalle_pago.OFICINA_ID;
          END IF;
          --
          msg_ret:='1551';
          -- busqueda cuenta contable por tipo
          r_cuenta_contable_por_tipo := GET_CUENTA_CONTABLE_POR_TIPO(
                                          Lv_ValorCampoRef,
                                          Lv_CampoReferencial,
                                          r_plantilla_contable_det.TIPO_CUENTA_CONTABLE_ID,
                                          pt_detalle_pago.COD_EMPRESA);
          --
          l_no_cta_contable := r_cuenta_contable_por_tipo.CUENTA;
          Lv_CentroCosto := r_cuenta_contable_por_tipo.CENTRO_COSTO;
        END IF;

        msg_ret:='1560';

        if r_plantilla_contable_det.POSICION='C' then
            l_valor_tipo:=-1;
        else
            l_valor_tipo:=1;
        end if;

        IF(l_no_cta_contable is not null) THEN

            IF(pt_plantilla_contable_cab.TABLA_DETALLE='MIGRA_ARCKML')THEN
              --
              l_migra_arckml.MIGRACION_ID   := pt_migra_arckmm.ID_MIGRACION;
              l_migra_arckml.NO_CIA         := pt_migra_arckmm.NO_CIA;
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
              l_migra_arckml.COD_DIARIO     := pt_migra_arckmm.COD_DIARIO;
              msg_ret:='1565';
              l_migra_arckml.GLOSA          := GENERA_COMENTARIO(pt_detalle_pago, '', r_plantilla_contable_det.FORMATO_GLOSA,null,null);
              msg_ret:='1570';

              l_migra_arckml.TIPO_MOV  := r_plantilla_contable_det.POSICION;
              l_migra_arckml.MONTO     := 0;
              l_migra_arckml.MONTO_DOl := 0;
              l_migra_arckml.MONTO_DC  := 0;

                    --SI EL PAGO GENERO ANTICIPO CREA EL REGISTRO PARA ANTICIPOS
                    IF(r_plantilla_contable_det.TIPO_CUENTA_CONTABLE='ANTICIPO CLIENTES') THEN
                        IF (pt_detalle_pago.MONTO_ANTICIPOS>0 AND pt_detalle_pago.TIPO_DOC='PAG') THEN
                            l_migra_arckml.MONTO          := pt_detalle_pago.MONTO_ANTICIPOS;
                            l_migra_arckml.MONTO_DOl      := pt_detalle_pago.MONTO_ANTICIPOS;
                            l_migra_arckml.MONTO_DC       := pt_detalle_pago.MONTO_ANTICIPOS;
                            IF (l_migra_arckml.MONTO <> 0) THEN
                              NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKML(l_migra_arckml,l_MsnError);
                            END IF;
                        ELSIF (pt_detalle_pago.TIPO_DOC='ANT') THEN
                            l_migra_arckml.MONTO          := pt_detalle_pago.MONTO;
                            l_migra_arckml.MONTO_DOl      := pt_detalle_pago.MONTO;
                            l_migra_arckml.MONTO_DC       := pt_detalle_pago.MONTO;
                            IF (l_migra_arckml.MONTO <> 0) THEN
                              NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKML(l_migra_arckml,l_MsnError);
                            END IF;
                        END IF;
                    ELSE
                        IF (r_plantilla_contable_det.POSICION = 'C') THEN
                            l_migra_arckml.MONTO     := pt_detalle_pago.MONTO;
                            l_migra_arckml.MONTO_DOl := pt_detalle_pago.MONTO;
                            l_migra_arckml.MONTO_DC  := pt_detalle_pago.MONTO;
                        ELSE
                            l_migra_arckml.MONTO     := pt_detalle_pago.MONTO + pt_detalle_pago.MONTO_ANTICIPOS;
                            l_migra_arckml.MONTO_DOl := pt_detalle_pago.MONTO + pt_detalle_pago.MONTO_ANTICIPOS;
                            l_migra_arckml.MONTO_DC  := pt_detalle_pago.MONTO + pt_detalle_pago.MONTO_ANTICIPOS;
                        END IF;
                        --INSERTA DEBITO O CREDITO DEL ASIENTO
                        ----------------------------
                        IF (l_migra_arckml.MONTO <> 0) THEN
                          NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKML(l_migra_arckml,l_MsnError);
                          if nvl(Lv_BanderaReplicar,'N') = 'S' AND pt_migra_arckmm.NO_CIA = Lv_EmpresaOrigen then
                            l_migra_arckml.MIGRACION_ID   := Pn_IdMigracion18;
                            l_migra_arckml .NO_CIA := Lv_EmpresaDestino;
                            
                            NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKML(l_migra_arckml,l_MsnError);
                            
                            l_migra_arckml.MIGRACION_ID   := pt_migra_arckmm.ID_MIGRACION;
                            l_migra_arckml.NO_CIA := pt_migra_arckmm.NO_CIA;
                          end if;
                        END IF;
                    END IF;

                    msg_ret:='1580';

                    IF l_MsnError IS NOT NULL THEN
                        DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNKG_CONTABILIZAR',
                            'PROCESAR_PAGO_ANTICIPO_MANUAL',msg_ret||':'||l_MsnError);
                        raise_application_error( -20008, 'Error al insertar asiento tipo '
                            || r_plantilla_contable_det.POSICION ||' en MIGRA_ARCKML' );
                    END IF;

            ELSIF(pt_plantilla_contable_cab.TABLA_DETALLE='MIGRA_ARCGAL')THEN
              --
              l_migra_arcgal.NO_CIA := pt_migra_arcgae.NO_CIA;
              l_migra_arcgal.CUENTA := l_no_cta_contable;
              l_migra_arcgal.Cc_1   := '000';
              l_migra_arcgal.Cc_2   := '000';
              l_migra_arcgal.Cc_3   := '000';
              --
              -- Tambien se valida si cuenta contable recuperar acepta centro de costos
              IF NAF47_TNET.CUENTA_CONTABLE.acepta_cc (l_migra_arcgal.NO_CIA, l_migra_arcgal.CUENTA) THEN
                --
                l_migra_arcgal.Cc_1   := SUBSTR(Lv_CentroCosto,1,3);
                l_migra_arcgal.Cc_2   := SUBSTR(Lv_CentroCosto,4,3);
                l_migra_arcgal.Cc_3   := SUBSTR(Lv_CentroCosto,7,3);
                --
              END IF;
              --
              --
              l_migra_arcgal.MIGRACION_ID           := pt_migra_arcgae.ID_MIGRACION; 
              l_migra_arcgal.ANO                    := pt_migra_arcgae.ANO;
              l_migra_arcgal.MES                    := pt_migra_arcgae.MES;
              l_migra_arcgal.NO_ASIENTO             := pt_migra_arcgae.NO_ASIENTO;
              l_migra_arcgal.NO_LINEA               := l_no_linea+1;
              l_migra_arcgal.DESCRI                 := GENERA_COMENTARIO( pt_detalle_pago,
                                                                          l_migra_arcgal.NO_ASIENTO,
                                                                          r_plantilla_contable_det.FORMATO_GLOSA,
                                                                          null,
                                                                          null );
              l_migra_arcgal.COD_DIARIO             := pt_migra_arcgae.COD_DIARIO;
              l_migra_arcgal.MONEDA                 := 'P';
              l_migra_arcgal.TIPO_CAMBIO            := 1;
              l_migra_arcgal.CENTRO_COSTO           := l_migra_arcgal.Cc_1 || l_migra_arcgal.Cc_2 || l_migra_arcgal.Cc_3;
              l_migra_arcgal.TIPO                   := 'D';
              l_migra_arcgal.LINEA_AJUSTE_PRECISION := 'N';
              l_migra_arcgal.MONTO                  := 0;
              l_migra_arcgal.MONTO_DOl              := 0;
              msg_ret:='1591';

                l_migra_arcgal.TIPO   := r_plantilla_contable_det.POSICION;

                msg_ret:='1592';
                --SI EL PAGO GENERO ANTICIPO CREA EL REGISTRO PARA ANTICIPOS
                IF(r_plantilla_contable_det.TIPO_CUENTA_CONTABLE='ANTICIPO CLIENTES') THEN
                    msg_ret:='1593';
                    IF (pt_detalle_pago.MONTO_ANTICIPOS > 0  AND pt_detalle_pago.TIPO_DOC='PAG') THEN
                        l_migra_arcgal.MONTO          := pt_detalle_pago.MONTO_ANTICIPOS * l_valor_tipo;
                        l_migra_arcgal.MONTO_DOl      := pt_detalle_pago.MONTO_ANTICIPOS * l_valor_tipo;
                        msg_ret:='1594';
                        --INSERTA DEBITO O CREDITO DEL ASIENTO ANTICIPOS
                        ----------------------------
                        IF (l_migra_arcgal.MONTO <> 0) THEN
                          NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAL(l_migra_arcgal,l_MsnError);
                          if nvl(Lv_BanderaReplicar,'N') = 'S' AND pt_migra_arcgae.NO_CIA = Lv_EmpresaOrigen then
                            l_migra_arcgal.NO_CIA := Lv_EmpresaDestino;
                            l_migra_arcgal.MIGRACION_ID := Pn_IdMigracion18;
                            
                            NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAL(l_migra_arcgal,l_MsnError);
                            
                            
                            l_migra_arcgal.NO_CIA := pt_migra_arcgae.NO_CIA;
                            l_migra_arcgal.MIGRACION_ID := pt_migra_arcgae.ID_MIGRACION;
                          end if;
                          l_no_linea := l_no_linea + 1;
                        END IF;
                        msg_ret:='1595';
                    --
		    --llindao: se considera documento ANTC en contabilizaci�n.
                    ELSIF pt_detalle_pago.TIPO_DOC IN ('ANT','ANTS','ANTC') THEN
                      --
                      l_migra_arcgal.MONTO     := pt_detalle_pago.MONTO * l_valor_tipo;
                      l_migra_arcgal.MONTO_DOl := pt_detalle_pago.MONTO * l_valor_tipo;
                      --
                      IF l_migra_arcgal.MONTO <> 0 THEN
                        --
                        NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAL(l_migra_arcgal,l_MsnError);
                        if nvl(Lv_BanderaReplicar,'N') = 'S' AND pt_migra_arcgae.NO_CIA = Lv_EmpresaOrigen then
                            l_migra_arcgal.NO_CIA := Lv_EmpresaDestino;
                            l_migra_arcgal.MIGRACION_ID := Pn_IdMigracion18;
                            
                            NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAL(l_migra_arcgal,l_MsnError);
                            
                            
                            l_migra_arcgal.NO_CIA := pt_migra_arcgae.NO_CIA;
                            l_migra_arcgal.MIGRACION_ID := pt_migra_arcgae.ID_MIGRACION;
                          end if;
                        --
                        l_no_linea := l_no_linea + 1;
                        --
                      ELSE
                        --
                        l_migra_arcgal.MONTO     := pt_detalle_pago.MONTO_ANTICIPOS * l_valor_tipo;
                        l_migra_arcgal.MONTO_DOl := pt_detalle_pago.MONTO_ANTICIPOS * l_valor_tipo;
                        --
                        IF l_migra_arcgal.MONTO <> 0 THEN
                          --
                          NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAL(l_migra_arcgal,l_MsnError);
                          if nvl(Lv_BanderaReplicar,'N') = 'S' AND pt_migra_arcgae.NO_CIA = Lv_EmpresaOrigen then
                            l_migra_arcgal.NO_CIA := Lv_EmpresaDestino;
                            l_migra_arcgal.MIGRACION_ID := Pn_IdMigracion18;
                            
                            NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAL(l_migra_arcgal,l_MsnError);
                            
                            
                            l_migra_arcgal.NO_CIA := pt_migra_arcgae.NO_CIA;
                            l_migra_arcgal.MIGRACION_ID := pt_migra_arcgae.ID_MIGRACION;
                          end if;
                          --
                          l_no_linea := l_no_linea + 1;
                          --
                        END IF;
                        --
                      END IF;
                      --
                    END IF;
                ELSE
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
                    IF (l_migra_arcgal.MONTO <> 0) THEN
                      NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAL(l_migra_arcgal,l_MsnError);
                      if nvl(Lv_BanderaReplicar,'N') = 'S' AND pt_migra_arcgae.NO_CIA = Lv_EmpresaOrigen then
                            l_migra_arcgal.NO_CIA := Lv_EmpresaDestino;
                            l_migra_arcgal.MIGRACION_ID := Pn_IdMigracion18;
                            
                            NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAL(l_migra_arcgal,l_MsnError);
                            
                            
                            l_migra_arcgal.NO_CIA := pt_migra_arcgae.NO_CIA;
                            l_migra_arcgal.MIGRACION_ID := pt_migra_arcgae.ID_MIGRACION;
                          end if;
                      l_no_linea := l_no_linea + 1;
                    END IF;
                    msg_ret:='1597';
                END IF;

                IF l_MsnError IS NOT NULL THEN
                    msg_ret:='1598';
                    DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNKG_CONTABILIZAR',
                        'PROCESAR_PAGO_ANTICIPO_MANUAL',msg_ret||':'||l_MsnError);
                    raise_application_error( -20007, 'Error al insertar asiento tipo  '
                        || r_plantilla_contable_det.POSICION ||' en MIGRA_ARCGAL' );
                    msg_ret:='1599';
                END IF;

            END IF;
            --
        ELSE
            DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNKG_CONTABILIZAR',
                'PROCESAR_PAGO_ANTICIPO_MANUAL','Error al insertar asiento tipo '
                || r_plantilla_contable_det.POSICION ||', no se encontro cuenta contable');
            raise_application_error( -20009, 'Error al insertar asiento tipo '
                || r_plantilla_contable_det.POSICION ||', no se encontro cuenta contable' );

        END IF;

    END LOOP;

    msg_ret:='OK';
    CLOSE c_admi_plantilla_contab_det;

    EXCEPTION
      --
      WHEN ex_insert_arcgal THEN
        --
        msg_ret := msg_ret||' : '|| DBMS_UTILITY.FORMAT_ERROR_STACK;
        --
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                              'FNKG_CONTABILIZAR_PAGO_MANUAL.CREA_DEBITO_CREDITO',
                                              msg_ret,
                                              NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                              SYSDATE,
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
        --
        ROLLBACK;
        --
      WHEN ex_insert_arckml THEN
        --
        msg_ret := msg_ret||' : '|| DBMS_UTILITY.FORMAT_ERROR_STACK;
        --
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                              'FNKG_CONTABILIZAR_PAGO_MANUAL.CREA_DEBITO_CREDITO',
                                              msg_ret,
                                              NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                              SYSDATE,
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
        --
        ROLLBACK;
        --
      WHEN OTHERS THEN
        --
        msg_ret := msg_ret||' : '|| DBMS_UTILITY.FORMAT_ERROR_STACK;
        --
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                              'FNKG_CONTABILIZAR_PAGO_MANUAL.CREA_DEBITO_CREDITO',
                                              msg_ret,
                                              NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                              SYSDATE,
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
        --
        ROLLBACK;
        --
END CREA_DEBITO_CREDITO;
--

/*
* Documentaci�n para FUNCION 'GET_CUENTA_CONTABLE'.
* FUNCION QUE OBTIENE LA CUENTA CONTABLE SEGUN EL ID_CUENTA_CONTABLE
* @author Andres Montero amontero@telconet.ec
* @version 1.0
* @since 17/03/2016
*
* @author Luis Lindao <llindao@telconet.ec>
* @version 1.1  @since 11-01-2019  -  Se agrega recuperar centro costo y retornarlo en variable registro
*
* @Param number p_cuenta_contable_id (CUENTA_CONTABLE_ID del pago)
* @return  TypeCuentaContable
*/
FUNCTION GET_CUENTA_CONTABLE(p_cuenta_contable_id NUMBER)
  RETURN FNKG_TRANSACTION_CONTABILIZAR.TypeCuentaContable
IS

  CURSOR c_admi_cuenta_contable (cuenta_contable_id NUMBER)IS
    SELECT NO_CIA, 
      NO_CTA,
      CUENTA,
      TABLA_REFERENCIAL,
      CAMPO_REFERENCIAL,
      VALOR_CAMPO_REFERENCIAL, 
      NOMBRE_OBJETO_NAF,
      CENTRO_COSTO
    FROM DB_FINANCIERO.ADMI_CUENTA_CONTABLE 
    WHERE ID_CUENTA_CONTABLE = cuenta_contable_id ;

  r_cuenta_contable FNKG_TRANSACTION_CONTABILIZAR.TypeCuentaContable;

BEGIN
    --NUMERO CUENTA Y CUENTA CONTABLE DESTINO
    OPEN c_admi_cuenta_contable(p_cuenta_contable_id);
    FETCH c_admi_cuenta_contable INTO r_cuenta_contable.NO_CIA,
                                      r_cuenta_contable.NO_CTA,
                                      r_cuenta_contable.CUENTA,
                                      r_cuenta_contable.TABLA_REFERENCIAL,
                                      r_cuenta_contable.CAMPO_REFERENCIAL,
                                      r_cuenta_contable.VALOR_CAMPO_REFERENCIAL,
                                      r_cuenta_contable.NOMBRE_OBJETO_NAF,
                                      r_cuenta_contable.CENTRO_COSTO;
    CLOSE c_admi_cuenta_contable;

    RETURN r_cuenta_contable;
END;

/*
* Documentaci�n para FUNCION 'GET_CUENTA_CONTABLE_POR_TIPO'.
* FUNCION QUE OBTIENE LA CUENTA CONTABLE SEGUN EL ID_CUENTA_CONTABLE
* @author Andres Montero amontero@telconet.ec
* @version 1.0
* @since 17/03/2016
*
* @author Luis Lindao <llindao@telconet.ec>
* @version 1.1  @since 11-01-2019  -  Se agrega recuperar centro costo y retornarlo en variable registro
*
* @Param number   p_valor_campo_ref (valor campo referencia)
* @Param varchar2 p_nombre_campo_ref (nombre campo referencia)
* @Param number   p_id_tipo_cta_contable (id del tipo de cuenta contable)
* @Param varchar2 p_empresa_cod (id de empresa)
* @return  TypeCuentaContablePorTipo
*/
FUNCTION GET_CUENTA_CONTABLE_POR_TIPO(p_valor_campo_ref NUMBER,
    p_nombre_campo_ref VARCHAR2, p_id_tipo_cta_contable NUMBER, p_empresa_cod VARCHAR2)
  RETURN FNKG_TRANSACTION_CONTABILIZAR.TypeCuentaContablePorTipo
IS

  --cursor con informacion de la cuenta contable cuenta puente
  CURSOR C_ADMI_CUENTA_CONTABLE( pc_valor_campo_ref      NUMBER,
                                 pc_nombre_campo_ref     VARCHAR2,
                                 pc_id_tipo_cta_contable NUMBER ) IS
    SELECT CC.NO_CIA,
      CC.CUENTA,
      CC.CENTRO_COSTO
    FROM DB_FINANCIERO.ADMI_CUENTA_CONTABLE CC
    WHERE CC.TIPO_CUENTA_CONTABLE_ID = pc_id_tipo_cta_contable
    AND CC.VALOR_CAMPO_REFERENCIAL = pc_valor_campo_ref
    AND CC.CAMPO_REFERENCIAL = pc_nombre_campo_ref
    AND CC.EMPRESA_COD = p_empresa_cod
    AND CC.ESTADO = 'Activo';



  r_cuenta_contable FNKG_TRANSACTION_CONTABILIZAR.TypeCuentaContablePorTipo;

BEGIN
    
    OPEN c_admi_cuenta_contable(p_valor_campo_ref,
                                p_nombre_campo_ref,
                                p_id_tipo_cta_contable);
    FETCH c_admi_cuenta_contable INTO r_cuenta_contable.NO_CIA,
                                      r_cuenta_contable.CUENTA,
                                      r_cuenta_contable.CENTRO_COSTO;
    CLOSE c_admi_cuenta_contable;

    RETURN r_cuenta_contable;

END;





/*
* Documentaci�n para FUNCION 'GET_PLANTILLA_CONTABLE_CAB'.
* FUNCION QUE OBTIENE LA CABECERA DE LA PLANTILLA CONTABLE
* @author Andres Montero amontero@telconet.ec
* @version 1.0
* @since 17/03/2016
*
* @author Luis Lindao <llindao@telconet.ec>
* @version 1.1 23-03-2021 - se agrega b�squeda solo por tipo documento y empresa.
*
* @Param varchar2 p_empresa_cod (EMPRESA_COD de la plantilla)
* @Param number   p_forma_pago_id (FORMA_PAGO_ID de la plantilla)
* @Param number   p_tipo_documento_id (TIPO_DOCUMENTO_ID de la plantilla)
* @Param varchar2 p_tipo_proceso (TIPO_PROCESO tipo de proceso de la plantilla)
* @return  TypePlantillaContableCab
*/
FUNCTION GET_PLANTILLA_CONTABLE_CAB(p_empresa_cod VARCHAR2, p_forma_pago_id NUMBER ,
p_tipo_documento_id NUMBER,p_tipo_proceso VARCHAR2)
  RETURN FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableCab
IS
  --cursor con informacion de la cuenta contable cuenta puente
  CURSOR c_plantilla_cab (pc_empresa_cod VARCHAR2, pc_forma_pago_id NUMBER , pc_tipo_documento_id NUMBER)
  IS
  SELECT pcc.ID_PLANTILLA_CONTABLE_CAB,tdf.ID_TIPO_DOCUMENTO,
  tdf.CODIGO_TIPO_DOCUMENTO,fp.ID_FORMA_PAGO, fp.CODIGO_FORMA_PAGO,
  pcc.TABLA_CABECERA, pcc.TABLA_DETALLE,pcc.COD_DIARIO,pcc.FORMATO_NO_DOCU_ASIENTO, pcc.FORMATO_GLOSA,
  pcc.NOMBRE_PAQUETE_SQL, pcc.TIPO_DOC
  FROM DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB pcc
  JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO tdf ON pcc.tipo_documento_id=tdf.id_tipo_documento
  JOIN DB_GENERAL.ADMI_FORMA_PAGO fp ON pcc.forma_pago_id=fp.id_forma_pago
  WHERE
  pcc.empresa_cod=pc_empresa_cod
  AND pcc.forma_pago_id= pc_forma_pago_id
  AND pcc.tipo_documento_id=pc_tipo_documento_id
  AND pcc.TIPO_PROCESO=p_tipo_proceso
  AND pcc.ESTADO='Activo';

    --cursor con informacion de la cuenta contable cuenta puente
    -- costo: 9
    CURSOR c_plantilla ( pc_empresa_cod       VARCHAR2, 
                         pc_tipo_documento_id NUMBER) IS
      SELECT pcc.ID_PLANTILLA_CONTABLE_CAB,
             tdf.ID_TIPO_DOCUMENTO,
             tdf.CODIGO_TIPO_DOCUMENTO,
             null as ID_FORMA_PAGO, 
             null as CODIGO_FORMA_PAGO,
             pcc.TABLA_CABECERA, 
             pcc.TABLA_DETALLE,
             pcc.COD_DIARIO,
             pcc.FORMATO_NO_DOCU_ASIENTO, 
             pcc.FORMATO_GLOSA,
             pcc.NOMBRE_PAQUETE_SQL, 
             pcc.TIPO_DOC
      FROM DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB pcc
      JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO tdf ON pcc.tipo_documento_id = tdf.id_tipo_documento
      WHERE pcc.empresa_cod = pc_empresa_cod
      AND pcc.forma_pago_id is null
      AND pcc.tipo_documento_id = pc_tipo_documento_id
      AND pcc.TIPO_PROCESO = p_tipo_proceso
      AND pcc.ESTADO = 'Activo';
    --
  r_plantilla_cont_cab FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableCab;

BEGIN
    -- si forma pago tiene valor se hace la busqueda regular
    IF p_forma_pago_id IS NOT NULL THEN
      --
      OPEN c_plantilla_cab(p_empresa_cod,p_forma_pago_id,p_tipo_documento_id);
      FETCH c_plantilla_cab INTO r_plantilla_cont_cab.ID_PLANTILLA_CONTABLE_CAB, r_plantilla_cont_cab.ID_TIPO_DOCUMENTO,
                                 r_plantilla_cont_cab.CODIGO_TIPO_DOCUMENTO, r_plantilla_cont_cab.ID_FORMA_PAGO,
                                 r_plantilla_cont_cab.CODIGO_FORMA_PAGO,
                                 r_plantilla_cont_cab.TABLA_CABECERA,
                                 r_plantilla_cont_cab.TABLA_DETALLE,
                                 r_plantilla_cont_cab.COD_DIARIO,
                                 r_plantilla_cont_cab.FORMATO_NO_DOCU_ASIENTO,
                                 r_plantilla_cont_cab.FORMATO_GLOSA,
                                 r_plantilla_cont_cab.NOMBRE_PAQUETE_SQL,
                                 r_plantilla_cont_cab.TIPO_DOC;
      CLOSE c_plantilla_cab;
      --
    -- caso contrario se realia busqueda solo por tipo documento sin forma de pago
    ELSE
      --
      OPEN c_plantilla (p_empresa_cod,p_tipo_documento_id);
      FETCH c_plantilla INTO r_plantilla_cont_cab.ID_PLANTILLA_CONTABLE_CAB, r_plantilla_cont_cab.ID_TIPO_DOCUMENTO,
                             r_plantilla_cont_cab.CODIGO_TIPO_DOCUMENTO, r_plantilla_cont_cab.ID_FORMA_PAGO,
                             r_plantilla_cont_cab.CODIGO_FORMA_PAGO,
                             r_plantilla_cont_cab.TABLA_CABECERA,
                             r_plantilla_cont_cab.TABLA_DETALLE,
                             r_plantilla_cont_cab.COD_DIARIO,
                             r_plantilla_cont_cab.FORMATO_NO_DOCU_ASIENTO,
                             r_plantilla_cont_cab.FORMATO_GLOSA,
                             r_plantilla_cont_cab.NOMBRE_PAQUETE_SQL,
                             r_plantilla_cont_cab.TIPO_DOC;
      --
    END IF;
    --
    RETURN r_plantilla_cont_cab;
    --
END;






/*
* Documentaci�n para FUNCION 'GET_PLANTILLA_CONTABLE_CAB_COD'.
* FUNCION QUE OBTIENE LA CABECERA DE LA PLANTILLA CONTABLE
* @author Andres Montero amontero@telconet.ec
* @version 1.0
* @since 17/03/2016
* @Param varchar2 p_empresa_cod (EMPRESA_COD de la plantilla)
* @Param number   p_cod_forma_pago (CODIGO_FORMA_PAGO codigo de la forma de pago)
* @Param number   p_tipo_documento_id (CODIGO_TIPO_DOCUMENTO codigo del tipo de documento)
* @Param varchar2 p_tipo_proceso (TIPO_PROCESO tipo de proceso de la plantilla)
* @return  TypePlantillaContableCab
*/
FUNCTION GET_PLANTILLA_CONTABLE_CAB_COD(p_empresa_cod VARCHAR2, p_cod_forma_pago VARCHAR2 ,
p_cod_tipo_documento VARCHAR2,p_tipo_proceso VARCHAR2)
  RETURN FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableCab
IS
  --cursor con informacion de la cuenta contable cuenta puente
  CURSOR c_plantilla_cab (pc_empresa_cod VARCHAR2, p_cod_forma_pago VARCHAR2 , p_cod_tipo_documento VARCHAR2)
  IS
  SELECT pcc.ID_PLANTILLA_CONTABLE_CAB,tdf.ID_TIPO_DOCUMENTO,
  tdf.CODIGO_TIPO_DOCUMENTO,fp.ID_FORMA_PAGO, fp.CODIGO_FORMA_PAGO,
  pcc.TABLA_CABECERA, pcc.TABLA_DETALLE,pcc.COD_DIARIO,pcc.FORMATO_NO_DOCU_ASIENTO,pcc.FORMATO_GLOSA,
  pcc.NOMBRE_PAQUETE_SQL, pcc.TIPO_DOC
  FROM DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB pcc
  JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO tdf ON pcc.tipo_documento_id=tdf.id_tipo_documento
  JOIN DB_GENERAL.ADMI_FORMA_PAGO fp ON pcc.forma_pago_id=fp.id_forma_pago
  WHERE
  pcc.empresa_cod=pc_empresa_cod
  AND fp.codigo_forma_pago= p_cod_forma_pago
  AND tdf.codigo_tipo_documento=p_cod_tipo_documento
  AND pcc.TIPO_PROCESO=p_tipo_proceso
  AND pcc.ESTADO='Activo';

  r_plantilla_cont_cab FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableCab;

BEGIN

    OPEN c_plantilla_cab(p_empresa_cod,p_cod_forma_pago,p_cod_tipo_documento);
    FETCH c_plantilla_cab
    INTO
    r_plantilla_cont_cab.ID_PLANTILLA_CONTABLE_CAB, r_plantilla_cont_cab.ID_TIPO_DOCUMENTO,
    r_plantilla_cont_cab.CODIGO_TIPO_DOCUMENTO, r_plantilla_cont_cab.ID_FORMA_PAGO,
    r_plantilla_cont_cab.CODIGO_FORMA_PAGO,
    r_plantilla_cont_cab.TABLA_CABECERA,
    r_plantilla_cont_cab.TABLA_DETALLE,
    r_plantilla_cont_cab.COD_DIARIO,
    r_plantilla_cont_cab.FORMATO_NO_DOCU_ASIENTO,
    r_plantilla_cont_cab.FORMATO_GLOSA,
    r_plantilla_cont_cab.NOMBRE_PAQUETE_SQL,
    r_plantilla_cont_cab.TIPO_DOC;
    CLOSE c_plantilla_cab;

    RETURN r_plantilla_cont_cab;

END;


/*
* Documentaci�n para FUNCION 'GET_PLANTILLA_CONTABLE_DET'.
* FUNCION QUE OBTIENE DETALLE DE LA PLANTILLA CONTABLE
* @author Andres Montero amontero@telconet.ec
* @version 1.0
* @since 17/03/2016
* @Param number p_cabecera_id (id cabecera de la plantilla)
* @return  SYS_REFCURSOR
*/
FUNCTION GET_PLANTILLA_CONTABLE_DET(p_cabecera_id NUMBER)
  RETURN SYS_REFCURSOR
IS
    c_plantillas_det SYS_REFCURSOR;

BEGIN

    OPEN c_plantillas_det
    FOR
    SELECT pcd.id_plantilla_contable_det, pcd.POSICION, pcd.tipo_cuenta_contable_id, tcc.descripcion, pcd.FORMATO_GLOSA,pcd.DESCRIPCION
    FROM DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_DET pcd
    JOIN DB_FINANCIERO.ADMI_TIPO_CUENTA_CONTABLE tcc ON pcd.tipo_cuenta_contable_id=tcc.id_tipo_cuenta_contable
    WHERE pcd.plantilla_contable_cab_id =p_cabecera_id AND pcd.ESTADO='Activo' ORDER BY pcd.POSICION DESC;


    RETURN c_plantillas_det;
END;


/*
* Documentaci�n para FUNCION 'GET_PLANTILLA_CONTABLE_DET_POS'.
* FUNCION QUE OBTIENE DETALLE DE LA PLANTILLA CONTABLE POR CABECERA_ID Y POR POSICION
* @author Andres Montero amontero@telconet.ec
* @version 1.0
* @since 01/04/2016
* @Param number p_cabecera_id (id cabecera de la plantilla)
* @Param number p_posicion (debito:D o credito:C)
* @return  SYS_REFCURSOR
*/
FUNCTION GET_PLANTILLA_CONTABLE_DET_POS(p_cabecera_id NUMBER, p_posicion VARCHAR2)
  RETURN SYS_REFCURSOR
IS
    c_plantillas_det SYS_REFCURSOR;

BEGIN
    OPEN c_plantillas_det
    FOR
    SELECT pcd.id_plantilla_contable_det, pcd.POSICION, pcd.tipo_cuenta_contable_id,
    tcc.descripcion, pcd.FORMATO_GLOSA, pcd.DESCRIPCION
    FROM DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_DET pcd
    JOIN DB_FINANCIERO.ADMI_TIPO_CUENTA_CONTABLE tcc ON pcd.tipo_cuenta_contable_id=tcc.id_tipo_cuenta_contable
    WHERE pcd.plantilla_contable_cab_id =p_cabecera_id
    AND pcd.ESTADO='Activo'
    AND pcd.POSICION=p_posicion
    ORDER BY pcd.POSICION DESC;

    RETURN c_plantillas_det;

END;

/*
* Documentaci�n para FUNCION 'GET_CUENTA_CONTABLE'.
* FUNCION QUE OBTIENE LA CUENTA CONTABLE SEGUN EL ID_CUENTA_CONTABLE
* @author Andres Montero amontero@telconet.ec
* @version 1.0
* @since 17/03/2016
*
* Actualizacion: Se agrega validacion de longitud 255 y 240 de glosa para tablas de migracion del NAF
* @author Andres Montero amontero@telconet.ec
* @version 1.1 13/07/2016
*
* @author Luis Lindao <llindao@telconet.ec>
* @version 1.2 13/09/2018 - Se modifica para agregar configuraci�n de campos para conceptos documentos MD
*
* @Param FNKG_TRANSACTION_CONTABILIZAR.TypeDetallePagos lr_detalle_pago (datos del pago)
* @Param varchar2                                       no_asiento (numero del asiento)
* @Param varchar2                                       p_formato (formato del comentario)
* @Param FNKG_TRANSACTION_CONTABILIZAR.TypeDeposito     lr_deposito (datos del deposito)
* @return  VARCHAR2 (comentario ya construido)
*/
FUNCTION GENERA_COMENTARIO(lr_detalle_pago IN FNKG_TRANSACTION_CONTABILIZAR.TypeDetallePagos,
    cadena_adicional IN varchar2, p_formato IN varchar2,
    p_deposito IN FNKG_TRANSACTION_CONTABILIZAR.TypeDeposito,
    p_datos_debito IN FNKG_TRANSACTION_CONTABILIZAR.TypeDatosDebito)
  RETURN VARCHAR2
IS
  --
  CURSOR C_DATOS_ADICIONALES IS
    SELECT IPC.ID_PAGO,
           UPPER(REPLACE(REPLACE(IPC.COMENTARIO_PAGO,CHR(10),' '),CHR(13),' ')) AS COMENTARIO_PAGO,
           NVL(P.RAZON_SOCIAL, P.APELLIDOS||' '||P.NOMBRES) AS NOMBRE_CLIENTE,
           IPD.COMENTARIO AS COMENTARIO_DETALLE_PAGO
    FROM INFO_PERSONA P,
         INFO_PERSONA_EMPRESA_ROL IPER,
         INFO_PUNTO IP,
         DB_FINANCIERO.INFO_PAGO_DET IPD,
         DB_FINANCIERO.INFO_PAGO_CAB IPC
    WHERE IPC.ID_PAGO = lr_detalle_pago.PAGO_ID
    AND IPER.PERSONA_ID = P.ID_PERSONA
    AND IP.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
    AND IPC.ID_PAGO = IPD.PAGO_ID
    AND IPC.PUNTO_ID = IP.ID_PUNTO;
    --
    Lr_DatoAdicional C_DATOS_ADICIONALES%ROWTYPE := NULL;
    --
    comentario varchar2(800):='';
    t_formato  TypeArreglo;
    t_fecha    TypeArreglo;
BEGIN

  P_SPLIT(p_formato,'|',t_formato);

  FOR i IN 0..t_formato.count - 1 loop

    IF t_formato(i) IN ('comentario_pago', 'nombre_cliente','comentario_det') AND Lr_DatoAdicional.Id_Pago IS NULL THEN
      IF C_DATOS_ADICIONALES%ISOPEN THEN
        CLOSE C_DATOS_ADICIONALES;
      END IF;
      OPEN C_DATOS_ADICIONALES;
      FETCH C_DATOS_ADICIONALES INTO Lr_DatoAdicional;
      IF C_DATOS_ADICIONALES%NOTFOUND THEN
        Lr_DatoAdicional := NULL;
      END IF;
      CLOSE C_DATOS_ADICIONALES;
    END IF;
    --
                         
    IF (t_formato(i) = 'numero_referencia') THEN
                             
       comentario := comentario || lr_detalle_pago.NUMERO_REFERENCIA;
                        
    ELSIF (t_formato(i) = 'comentario_pago') THEN
                             
       comentario := comentario || Lr_DatoAdicional.COMENTARIO_PAGO;

    ELSIF (t_formato(i) = 'nombre_cliente') THEN
                             
       comentario := comentario || Lr_DatoAdicional.NOMBRE_CLIENTE;

    ELSIF (t_formato(i) = 'comentario_det') THEN
                             
       comentario := comentario || Lr_DatoAdicional.COMENTARIO_DETALLE_PAGO;

    ELSIF (t_formato(i) = 'pag_fe_creacion') THEN

       comentario := comentario || TO_CHAR(lr_detalle_pago.FE_CREACION,'dd/mm/yyyy');

    ELSIF (t_formato(i) = 'fecha_deposito') THEN

       comentario := comentario || TO_CHAR(lr_detalle_pago.FE_DEPOSITO,'dd/mm/yyyy');

    ELSIF (t_formato(i) = 'numero_pago') THEN

       comentario := comentario || lr_detalle_pago.NUMERO_PAGO;

    ELSIF (t_formato(i) = 'no_asiento') THEN

       comentario := comentario || cadena_adicional;

    ELSIF (t_formato(i) = 'nombre_forma_pago') THEN

       comentario := comentario || lr_detalle_pago.FORMA_PAGO;

    ELSIF (t_formato(i) = 'codigo_tipo_documento') THEN

       comentario := comentario || lr_detalle_pago.TIPO_DOC;

    ELSIF (t_formato(i) = 'nombre_oficina') THEN

       comentario := comentario || lr_detalle_pago.OFICINA;

    ELSIF (t_formato(i) = 'dep_nombre_oficina') THEN

       comentario := comentario || p_deposito.NOMBRE_OFICINA;

    ELSIF (t_formato(i) = 'numero_cuenta_banco') THEN

       comentario := comentario || lr_detalle_pago.NUMERO_CUENTA_BANCO;

    ELSIF (t_formato(i) = 'login') THEN

       comentario := comentario || lr_detalle_pago.LOGIN;

    ELSIF (t_formato(i) = 'no_comprobante_deposito') THEN

       comentario:= comentario || p_deposito.NO_COMPROBANTE_DEPOSITO;

    ELSIF (t_formato(i) = 'dep_fe_proceso') THEN

       comentario := comentario || TO_CHAR(p_deposito.FE_PROCESADO,'dd/mm/yyyy');

    ELSIF (t_formato(i) = 'deb_banco') THEN

       comentario := comentario || p_datos_debito.NOMBRE_GRUPO;

    ELSIF (t_formato(i) = 'fe_actual') THEN

       comentario := comentario || TO_CHAR(SYSTIMESTAMP,'dd/mm/yyyy');

    ELSIF (t_formato(i) = 'deb_fe_creacion') THEN

    comentario := comentario || TO_CHAR(p_datos_debito.FE_CREACION,'dd/mm/yyyy');

    ELSIF (t_formato(i) = 'deb_oficina') THEN

       comentario := comentario || cadena_adicional;

    ELSIF (t_formato(i) = 'longitud_500') THEN

       comentario:=SUBSTR(comentario,1,500);

    ELSIF (t_formato(i) = 'longitud_100') THEN

       comentario:=SUBSTR(comentario,1,100);

    ELSIF (t_formato(i) = 'longitud_250') THEN

       comentario:=SUBSTR(comentario,1,250);

    ELSIF (t_formato(i) = 'longitud_255') THEN

       comentario:=SUBSTR(comentario,1,255);

    ELSIF (t_formato(i) = 'longitud_240') THEN

       comentario:=SUBSTR(comentario,1,240);

    ELSE

       comentario := comentario || t_formato(i);

    END IF;

  END LOOP;
  dbms_output.put_line(comentario);
  RETURN comentario;
END;


/*
* Documentaci�n para FUNCION 'GENERA_NO_DOCU_ASIENTO'.
* FUNCION QUE GENERA EL NUMERO DE DOCUMENTO O EL NUMERO DE ASIENTO PARA MIGRA_ARCKMM o MIGRA_ARCGAE respectivamente
* @author Andres Montero amontero@telconet.ec
* @version 1.0
* @since 17/03/2016
* @Param varchar2                                       p_formato (FORMATO con el que se genera el numero)
* @Param FNKG_TRANSACTION_CONTABILIZAR.TypeDetallePagos pt_detalle_pago (arreglo con los datos del pago)
* @return  VARCHAR2 (NUMERO GENERADO)
*/
FUNCTION GENERA_NO_DOCU_ASIENTO(p_formato in VARCHAR2, p_id IN NUMBER,
    pt_detalle_pago in FNKG_TRANSACTION_CONTABILIZAR.TypeDetallePagos) RETURN VARCHAR2
IS

numero_generado VARCHAR2(30):='';
t_formato TypeArreglo;
t_fecha   TypeArreglo;

BEGIN

IF p_formato = 'id' THEN

    numero_generado := p_id;

ELSE

    P_SPLIT(p_formato,'|',t_formato);

    FOR i IN 0..t_formato.count - 1 loop

         IF (t_formato(i) = 'id') THEN

         numero_generado := numero_generado || p_id;

         ELSIF (t_formato(i) = 'id_oficina') THEN

         numero_generado := numero_generado || pt_detalle_pago.OFICINA_ID;

         ELSIF (t_formato(i) = 'anio_fe_emision') THEN

             P_SPLIT(TO_CHAR(pt_detalle_pago.FE_CREACION,'YYYY-MM-DD'),'-',t_fecha);
             numero_generado:=numero_generado||t_fecha(0);

         ELSIF (t_formato(i) = 'anio2_fe_emision') THEN
             P_SPLIT(TO_CHAR(pt_detalle_pago.FE_CREACION,'YY-MM-DD'),'-',t_fecha);
             numero_generado:=numero_generado||t_fecha(0);

         ELSIF (t_formato(i) = 'mes_fe_emision') THEN
             P_SPLIT(TO_CHAR(pt_detalle_pago.FE_CREACION,'YYYY-MM-DD'),'-',t_fecha);
             numero_generado:=numero_generado||t_fecha(1);

         ELSIF (t_formato(i) = 'dia_fe_emision') THEN
             P_SPLIT(TO_CHAR(pt_detalle_pago.FE_CREACION,'YYYY-MM-DD'),'-',t_fecha);
             numero_generado:=numero_generado||t_fecha(2);

         ELSIF (t_formato(i) = 'hora_actual') THEN
             numero_generado:=numero_generado||TO_CHAR(SYSTIMESTAMP,'HH24MISS');

         ELSE
             numero_generado:=numero_generado||t_formato(i);
         END IF;
    end loop;
END IF;
RETURN numero_generado;
END;


/*
* Documentaci�n para PROCEDIMIENTO 'P_SPLIT'.
* FUNCION QUE DIVIDE EN CADENAS SEGUN CARACTER DE DIVISION
* @author Andres Montero amontero@telconet.ec
* @version 1.0
* @since 17/03/2016
* @Param in varchar2     Pv_Cadena (cadena a dividir)
* @Param in varchar2     Pv_Caracter (cadena de division)
* @Param out TypeArreglo Pr_Arreglo (arreglo con cadena dividida)
*/
PROCEDURE P_SPLIT(
  Pv_Cadena   IN VARCHAR2,
  Pv_Caracter IN VARCHAR2,
  Pr_Arreglo  OUT TypeArreglo
)
AS
  Ln_Idx number := 0;
BEGIN
    FOR CURRENT_ROW IN (
      WITH TEST AS
      (SELECT Pv_Cadena FROM DUAL)
      SELECT regexp_substr(Pv_Cadena, '[^'||Pv_Caracter||']+', 1, ROWNUM) SPLIT
      FROM TEST
      CONNECT BY LEVEL <= LENGTH (regexp_replace(Pv_Cadena, '[^'||Pv_Caracter||']+'))  + 1
    )
    LOOP
      Ln_Idx := Ln_Idx + 1;
      Pr_Arreglo(Pr_Arreglo.COUNT) := CURRENT_ROW.SPLIT;
    END LOOP;
END P_SPLIT;



/*
* Documentaci�n para FUNCION 'OBTIENE_PREFIJO_EMPRESA'.
* FUNCION QUE OBTIENE EL PREFIO DE LA EMPRESA
* @author Andres Montero amontero@telconet.ec
* @version 1.0
* @since 17/03/2016
* @Param in varchar2 p_empresa_cod (id de la empresa)
* @Return VARCHAR2 prefijo empresa
*/
FUNCTION OBTIENE_PREFIJO_EMPRESA (p_empresa_cod IN VARCHAR2) RETURN VARCHAR2
IS
l_prefijo_obtenido varchar2(4):='';
BEGIN
SELECT PREFIJO INTO l_prefijo_obtenido FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO WHERE cod_empresa=p_empresa_cod;
RETURN l_prefijo_obtenido;
END;



/*
* Documentaci�n para FUNCION 'MARCA_CONTABILIZADO_PAGO'.
* PROCEDIMIENTO QUE ACTUALIZA EL DETALLE DE PAGO COMO YA CONTABILIZADO
* @author Andres Montero amontero@telconet.ec
* @version 1.0
* @since 06/04/2016
* @Param in number p_pago_det_id (id del detalle del pago)
* @Param in number p_pago_id (id de la cabecera del pago)
* @Param in varchar2 p_estado_pago (estado de la cabecera del pago)
*/
PROCEDURE MARCA_CONTABILIZADO_PAGO(p_pago_det_id IN number, p_pago_id IN number, p_estado_pago IN varchar2)
IS
BEGIN
   dbms_output.put_line('se marco pago como contabilizado');
       --ACTUALIZA CAMPO CONTABILIZADO DE INFO_PAGO_DET
       UPDATE DB_FINANCIERO.INFO_PAGO_DET SET CONTABILIZADO='S' WHERE ID_PAGO_DET=p_pago_det_id;

       --INSERTA HISTORIAL PARA PAGO
       INSERT INTO DB_FINANCIERO.INFO_PAGO_HISTORIAL
       VALUES(
           SEQ_INFO_PAGO_HISTORIAL.NEXTVAL,
           p_pago_id,
           null,
           sysdate,
           'telcos',
           p_estado_pago,
           '[Proceso contable OK]'
        );

END MARCA_CONTABILIZADO_PAGO;






/*
* Documentaci�n para FUNCION 'GET_ANTICIPO_ADICIONAL'.
* FUNCION QUE OBTIENE ANTICIPOS QUE FUERON CREADOS POR UN PAGO
* @author Andres Montero amontero@telconet.ec
* @version 1.0
* @since 21/05/2016
* @Param number p_cabecera_id (id cabecera de PAGO)
* @return  SYS_REFCURSOR
*/
FUNCTION GET_ANTICIPO_ADICIONAL(p_cabecera_id NUMBER)
  RETURN SYS_REFCURSOR
IS
    c_pagos_det SYS_REFCURSOR;

BEGIN
    OPEN c_pagos_det
    FOR
    SELECT pdet.valor_pago
    FROM DB_FINANCIERO.INFO_PAGO_CAB pcab
    JOIN DB_FINANCIERO.INFO_PAGO_DET pdet ON pcab.id_pago=pdet.pago_id
    WHERE pcab.pago_id =p_cabecera_id;




    RETURN c_pagos_det;

END;
  --
  --
  PROCEDURE PROCESAR_PAGO_ANTICIPO_MANUAL(  
      v_no_cia          IN VARCHAR2,
      v_pago_det_id     IN NUMBER,
      Pv_GeneraAnticipo IN VARCHAR2,
      msg_ret           OUT VARCHAR2)
  IS
    --
    lr_detalle_pago FNKG_TRANSACTION_CONTABILIZAR.TypeDetallePagos;
    --
    --cursor para detalle del pago para contabilizacion
    CURSOR c_pagos ( Cn_PagoDetId DB_FINANCIERO.INFO_PAGO_DET.ID_PAGO_DET%TYPE,
                     Cv_NombrePaqueteSQL DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.NOMBRE_PAQUETE_SQL%TYPE,
                     Cv_EmpresaCod DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.EMPRESA_COD%TYPE,
                     Cv_EstadoActivo DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.ESTADO%TYPE )
    IS
      -- se agrega campo TIPO_PROCESO que identifica si ANTC se contabiliza
      -- costo: 13
      SELECT pdet.id_pago_det,
        fp.descripcion_forma_pago forma_pago,
        fp.codigo_forma_pago,
        pdet.valor_pago monto,
        pdet.fe_creacion,
        pcab.numero_pago,
        pdet.numero_cuenta_banco,
        pto.login,
        pcab.usr_creacion,
        ofi.nombre_oficina oficina,
        pdet.cuenta_contable_id,
        pdet.numero_referencia,
        pcab.oficina_id,
        emp.prefijo,
        tdf.codigo_tipo_documento tipo_doc,
        pdet.pago_id,
        fp.id_forma_pago,
        pcab.tipo_documento_id,
        emp.cod_empresa,
        pdet.fe_deposito,
        pcab.punto_id,
        pcab.estado_pago,
        0 monto_anticipos,
        pdet.banco_tipo_cuenta_id,
        pdet.tipo_proceso 
      FROM DB_FINANCIERO.INFO_PAGO_DET pdet
      JOIN DB_COMERCIAL.ADMI_FORMA_PAGO fp
      ON pdet.forma_pago_id=fp.id_forma_pago
      JOIN DB_FINANCIERO.INFO_PAGO_CAB pcab
      ON pdet.pago_id=pcab.id_pago
      LEFT JOIN DB_COMERCIAL.INFO_PUNTO pto
      ON pcab.punto_id=pto.id_punto
      JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO ofi
      ON pcab.oficina_id=ofi.id_oficina
      JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO emp
      ON ofi.empresa_id=emp.cod_empresa
      JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO tdf
      ON tdf.id_tipo_documento=pcab.tipo_documento_id
      LEFT JOIN NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO MDA
      ON MDA.DOCUMENTO_ORIGEN_ID     = pdet.ID_PAGO_DET
      WHERE pdet.id_pago_det         = Cn_PagoDetId
      AND pcab.DEBITO_GENERAL_HISTORIAL_ID IS NULL
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
    c_admi_plantilla_contab_det SYS_REFCURSOR ;
    c_pagos_det                 SYS_REFCURSOR ;

    r_cuenta_contable FNKG_TRANSACTION_CONTABILIZAR.TypeCuentaContable;
    r_cuenta_contable_por_tipo FNKG_TRANSACTION_CONTABILIZAR.TypeCuentaContablePorTipo;
    r_plantilla_contable_cab FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableCab;
    r_plantilla_contable_det FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableDet;

    l_migra_arckmm NAF47_TNET.MIGRA_ARCKMM%ROWTYPE;
    l_migra_arcgae NAF47_TNET.MIGRA_ARCGAE%ROWTYPE;

    l_MsnError varchar2(500);
    l_msn_debito_credito varchar2(500);

    l_tipo_doc            varchar2(4) :='NC';
    l_anio                varchar2(4);
    l_mes                 varchar2(2);
    l_numero_cuenta_banco varchar2(20) :='0000000000';
    l_no_fisico           varchar2(20);
    l_serie_fisico        varchar2(20);
    l_no_cta              varchar2(20) :='';
    l_no_docu             varchar2(50) :='';
    l_fecha_docu          date;
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

  Le_MigraDocumentoAsociado EXCEPTION;
  PRAGMA EXCEPTION_INIT( Le_MigraDocumentoAsociado, -20010 );
  --
  Lv_NombrePaqueteSQL DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.NOMBRE_PAQUETE_SQL%TYPE := 'FNKG_CONTABILIZAR_PAGO_MANUAL';
  Lv_EstadoActivo DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.ESTADO%TYPE                 := 'Activo';
  Lv_TipoProceso      DB_FINANCIERO.INFO_PAGO_DET.TIPO_PROCESO%TYPE:= 'Pago';
  --
  Lr_MigraDocumentoAsociado NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO%ROWTYPE;
  --
  Ln_IdMigracion33 naf47_tnet.migra_arcgae.id_migracion%type;
  Ln_IdMigracion18 naf47_tnet.migra_arcgae.id_migracion%type;
  
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
                                          'Ejecucion del proceso FNKG_CONTABILIZAR_PAGO_MANUAL.PROCESAR_PAGO_ANTICIPO_MANUAL con los sgtes parametros: empresaCod:' || v_no_cia || ' pagoDetId: ' || v_pago_det_id || ' strGeneraAnticipo: ' || Pv_GeneraAnticipo,
                                          'telcos',
                                          SYSDATE,    
                                          '172.0.0.1');
                                          
    OPEN c_pagos(v_pago_det_id, Lv_NombrePaqueteSQL, v_no_cia, Lv_EstadoActivo);
    msg_ret:='1000';
    --RECORRE LOS DATOS DEL DETALLE DE PAGO
    FETCH c_pagos INTO lr_detalle_pago.ID_PAGO_DET,
                       lr_detalle_pago.FORMA_PAGO,
                       lr_detalle_pago.CODIGO_FORMA_PAGO,
                       lr_detalle_pago.MONTO,
                       lr_detalle_pago.FE_CREACION,
                       lr_detalle_pago.NUMERO_PAGO,
                       lr_detalle_pago.NUMERO_CUENTA_BANCO,
                       lr_detalle_pago.LOGIN,
                       lr_detalle_pago.USR_CREACION,
                       lr_detalle_pago.OFICINA,
                       lr_detalle_pago.CUENTA_CONTABLE_ID,
                       lr_detalle_pago.NUMERO_REFERENCIA,
                       lr_detalle_pago.OFICINA_ID,
                       lr_detalle_pago.PREFIJO,
                       lr_detalle_pago.TIPO_DOC,
                       lr_detalle_pago.PAGO_ID,
                       lr_detalle_pago.ID_FORMA_PAGO,
                       lr_detalle_pago.TIPO_DOCUMENTO_ID,
                       lr_detalle_pago.COD_EMPRESA,
                       lr_detalle_pago.FE_DEPOSITO,
                       lr_detalle_pago.PUNTO_ID,
                       lr_detalle_pago.ESTADO_PAGO,
                       lr_detalle_pago.MONTO_ANTICIPOS,
                       Gn_BancoTipoCtaId,
                       Lv_TipoProceso;

    --VERIFICA SI EL PAGO GENERO UN ANTICIPO
    IF TRIM(Pv_GeneraAnticipo) IS NOT NULL AND TRIM(Pv_GeneraAnticipo) = 'S' THEN
      --
      c_pagos_det := GET_ANTICIPO_ADICIONAL(lr_detalle_pago.PAGO_ID);
      LOOP
          valor_anticipo := 0;
          FETCH c_pagos_det INTO valor_anticipo;

          EXIT WHEN c_pagos_det%NOTFOUND;

          total_anticipo:=total_anticipo+valor_anticipo;

      END LOOP;
      --
      --
      IF total_anticipo > 0 THEN
        --
        lr_detalle_pago.MONTO_ANTICIPOS := total_anticipo;
        --
      END IF;
      --
      dbms_output.put_line('MONTO_ANTICIPOS:'||lr_detalle_pago.MONTO_ANTICIPOS);
      --
    END IF;--TRIM(Pv_GeneraAnticipo) IS NOT NULL AND TRIM(Pv_GeneraAnticipo) = 'S'

    IF lr_detalle_pago.id_pago_det IS NOT NULL THEN

        dbms_output.put_line('formaPago:'||lr_detalle_pago.FORMA_PAGO);
        dbms_output.put_line('tipoDoc:'||lr_detalle_pago.TIPO_DOC);

        msg_ret:='1100';

        --OBTIENE EL NUMERO DE CUENTA O TARJETA DE CREDITO
        IF(lr_detalle_pago.NUMERO_REFERENCIA IS NOT NULL) THEN
           l_numero_cuenta_banco:= lr_detalle_pago.NUMERO_REFERENCIA;
        ELSE
           l_numero_cuenta_banco := '0000000000';
        END IF;

        l_serie_fisico:=NULL;

        msg_ret:='1200';

        l_fecha_docu := lr_detalle_pago.FE_DEPOSITO;

        msg_ret:='1210';

        --OBTIENE ANIO Y MES DE LA FECHA DE DOCUMENTO
        l_anio:= TO_CHAR(lr_detalle_pago.FE_CREACION,'YYYY');
        msg_ret:='1220';

        l_mes := TO_CHAR(lr_detalle_pago.FE_CREACION,'MM');
        msg_ret:='1230';

        --OBTIENE TIPO DE DOCUMENTO
        IF (lr_detalle_pago.CODIGO_FORMA_PAGO = 'TRNG' OR  lr_detalle_pago.CODIGO_FORMA_PAGO = 'TARC' OR
            lr_detalle_pago.CODIGO_FORMA_PAGO = 'DEB' OR lr_detalle_pago.CODIGO_FORMA_PAGO = 'TRAN' OR
            lr_detalle_pago.CODIGO_FORMA_PAGO = 'TRMA' OR lr_detalle_pago.CODIGO_FORMA_PAGO = 'TGMA') THEN
            l_tipo_doc :='NC';
        ELSE
            l_tipo_doc :='DP';
        END IF;

        msg_ret:='1300';
        --
	-- Si ANTC se contabiliza se blanquea variable de busqueda forma de pago
        IF Lv_TipoProceso = 'AnticipoNotaCredito' THEN
           lr_detalle_pago.ID_FORMA_PAGO := NULL;
        END IF;
        --
        --OBTIENE DATOS DE LA CABECERA DE LA PLANTILLA
        r_plantilla_contable_cab :=
            GET_PLANTILLA_CONTABLE_CAB(lr_detalle_pago.COD_EMPRESA,
            lr_detalle_pago.ID_FORMA_PAGO , lr_detalle_pago.TIPO_DOCUMENTO_ID,'INDIVIDUAL');
        DBMS_OUTPUT.PUT_LINE('idcab:'||r_plantilla_contable_cab.ID_PLANTILLA_CONTABLE_CAB
            || ' cab:' ||r_plantilla_contable_cab.TABLA_CABECERA);
        dbms_output.put_line('NOMBRE_PAQUETE_SQL:'||r_plantilla_contable_cab.NOMBRE_PAQUETE_SQL);
        IF (r_plantilla_contable_cab.NOMBRE_PAQUETE_SQL='FNKG_CONTABILIZAR_PAGO_MANUAL') THEN

            msg_ret:='1310';

            --GENERA EL NUMERO DE DOCUMENTO
            l_no_docu:=FNKG_CONTABILIZAR_PAGO_MANUAL.GENERA_NO_DOCU_ASIENTO(r_plantilla_contable_cab.FORMATO_NO_DOCU_ASIENTO,
                lr_detalle_pago.ID_PAGO_DET, lr_detalle_pago);
            msg_ret:='1311';
            --OBTIENE NUMERO FISICO Y SERIE
            IF LENGTH(l_no_docu)>12 AND lr_detalle_pago.CODIGO_FORMA_PAGO <> 'TARC'
                AND lr_detalle_pago.CODIGO_FORMA_PAGO <> 'TRAN' THEN
                l_no_fisico    := lr_detalle_pago.NUMERO_REFERENCIA;
            msg_ret:='1312';
            ELSIF (lr_detalle_pago.CODIGO_FORMA_PAGO = 'TARC' AND lr_detalle_pago.CODIGO_FORMA_PAGO = 'TRAN') THEN

                SELECT count(*) INTO l_cantidad_detalles FROM DB_FINANCIERO.INFO_PAGO_DET WHERE PAGO_ID= lr_detalle_pago.PAGO_ID;

                l_no_fisico    := REPLACE(lr_detalle_pago.NUMERO_PAGO,'-','') || l_cantidad_detalles;
                l_serie_fisico := NULL;
            ELSE
                l_no_fisico  := l_numero_cuenta_banco;

            END IF;
            msg_ret:='1313';
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

                    msg_ret:='1330';

                    -- Nueva funci�n recupera cuenta bancaria, es mandatoria la b�squeda por id cuenta contable
                    r_cuenta_contable := FNCK_CONSULTS.F_GET_CUENTA_BANCARIA (
                                         lr_detalle_pago.CUENTA_CONTABLE_ID,
                                         Gn_BancoTipoCtaId,
                                         lr_detalle_pago.COD_EMPRESA);
                    --
                    l_no_cta:= r_cuenta_contable.NO_CTA;
                    if nvl(Lv_BanderaReplicar,'N') = 'S' AND v_no_cia = Lv_EmpresaOrigen then
                       l_migra_arckmm.ID_MIGRACION := NAF47_TNET.TRANSA_ID.MIGRA_CK( Lv_EmpresaOrigen );
                       Ln_IdMigracion33 := l_migra_arckmm.ID_MIGRACION;
                       Ln_IdMigracion18 := NAF47_TNET.TRANSA_ID.MIGRA_CK( Lv_EmpresaDestino );
                    else
                      l_migra_arckmm.ID_MIGRACION := NAF47_TNET.TRANSA_ID.MIGRA_CK( v_no_cia );
                    end if;
                    --
                    Lr_MigraDocumentoAsociado.MIGRACION_ID   := l_migra_arckmm.ID_MIGRACION;
                    Lr_MigraDocumentoAsociado.TIPO_MIGRACION := 'CK';
                    --
                    l_migra_arckmm.ID_FORMA_PAGO          := lr_detalle_pago.ID_FORMA_PAGO;
                    l_migra_arckmm.ID_OFICINA_FACTURACION := lr_detalle_pago.OFICINA_ID;
                    --
                    l_migra_arckmm.NO_CIA          := v_no_cia;
                    l_migra_arckmm.NO_CTA          := l_no_cta;
                    l_migra_arckmm.PROCEDENCIA     := 'C';
                    l_migra_arckmm.TIPO_DOC        := l_tipo_doc;
                    l_migra_arckmm.NO_DOCU         := l_no_docu;
                    l_migra_arckmm.FECHA           := lr_detalle_pago.FE_CREACION;
                    l_migra_arckmm.COMENTARIO      := GENERA_COMENTARIO(lr_detalle_pago, '', r_plantilla_contable_cab.FORMATO_GLOSA,null,null);
                    l_migra_arckmm.MONTO           := lr_detalle_pago.MONTO + lr_detalle_pago.MONTO_ANTICIPOS;
                    l_migra_arckmm.ESTADO          := 'P';
                    l_migra_arckmm.CONCILIADO      := 'N';
                    l_migra_arckmm.MES             := TO_NUMBER(l_mes);
                    l_migra_arckmm.ANO             := TO_NUMBER(l_anio);
                    l_migra_arckmm.IND_OTROMOV     := 'S';
                    l_migra_arckmm.MONEDA_CTA      := 'P';
                    l_migra_arckmm.TIPO_CAMBIO     := '1';
                    l_migra_arckmm.T_CAMB_C_V      := 'C';
                    l_migra_arckmm.IND_OTROS_MESES := 'N';
                    l_migra_arckmm.NO_FISICO       := l_no_fisico;
                    l_migra_arckmm.ORIGEN          := lr_detalle_pago.PREFIJO;
                    l_migra_arckmm.USUARIO_CREACION:= lr_detalle_pago.USR_CREACION;
                    l_migra_arckmm.FECHA_DOC       := lr_detalle_pago.FE_CREACION;
                    l_migra_arckmm.IND_DIVISION    := 'N';
                    l_migra_arckmm.FECHA_CREACION  := sysdate;
                    l_migra_arckmm.COD_DIARIO      := r_plantilla_contable_cab.COD_DIARIO;

                    msg_ret:='1335';

                    dbms_output.put_line('NO_DOCU:'||l_migra_arckmm.NO_DOCU||',  NO_CTA:'||l_migra_arckmm.NO_CTA);

                    IF (l_migra_arckmm.NO_DOCU IS NOT NULL AND l_migra_arckmm.NO_CTA IS NOT NULL) THEN

                        --INSERTA CABECERA DEL ASIENTO
                        NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKMM(l_migra_arckmm,l_MsnError);
                        --
                        --
                        if nvl(Lv_BanderaReplicar,'N') = 'S' AND v_no_cia = Lv_EmpresaOrigen then
                          declare
                           Ln_IdOficina DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%type;
                          begin
                            select id_oficina INTO Ln_IdOficina
                              from DB_COMERCIAL.INFO_OFICINA_GRUPO b
                             where b.NOMBRE_OFICINA = (select replace(A.NOMBRE_OFICINA, 'ECUANET', 'MEGADATOS')
                                                         from DB_COMERCIAL.INFO_OFICINA_GRUPO a
                                                        where a.id_oficina = lr_detalle_pago.OFICINA_ID);
                         
                             l_migra_arckmm.NO_CIA            := Lv_EmpresaDestino;
                             l_migra_arckmm.ID_OFICINA_FACTURACION := Ln_IdOficina;
                             l_migra_arckmm.Id_Migracion     := Ln_IdMigracion18;
                             
                             NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKMM(l_migra_arckmm,l_MsnError);
                             
                             l_migra_arckmm.Id_Migracion     := Ln_IdMigracion33;
                             l_migra_arckmm.NO_CIA            := v_no_cia;
                             l_migra_arckmm.ID_OFICINA_FACTURACION := lr_detalle_pago.OFICINA_ID;
                          end;
                        end if;
                        --
                        l_MsnError := NULL;
                        --
                        IF (l_serie_fisico IS NOT NULL) THEN

                            l_migra_arckmm.SERIE_FISICO:=l_serie_fisico;
                            FNKG_TRANSACTION_CONTABILIZAR.UPDATE_MIGRA_ARCKMM(l_no_docu,v_no_cia,l_migra_arckmm,l_MsnError);
                        END IF;

                    ELSE
                      --
                      raise_application_error( -20006, 'No se realiza proceso contable, faltan datos para crear asiento. ID_PAGO_DET('
                                                       || v_pago_det_id || '), ID_EMPRESA(' || v_no_cia || ')' );
                      --
                    END IF;

                    IF l_MsnError IS NOT NULL THEN
                      --
                      raise_application_error( -20003, 'Error al insertar cabecera asiento en MIGRA_ARCKMM. ID_PAGO_DET(' || v_pago_det_id || '), '
                                                       || 'EMPRESA_ID(' || v_no_cia || ') : '||l_MsnError );
                      --
                    END IF;

                    msg_ret:='1340';

            ELSIF(r_plantilla_contable_cab.TABLA_CABECERA='MIGRA_ARCGAE')THEN

                    msg_ret:='1400';
                    
                    if nvl(Lv_BanderaReplicar,'N') = 'S' AND v_no_cia = Lv_EmpresaOrigen then
                       l_migra_arcgae.ID_MIGRACION := NAF47_TNET.TRANSA_ID.MIGRA_CG( Lv_EmpresaOrigen );
                       Ln_IdMigracion33 := l_migra_arcgae.ID_MIGRACION;
                       Ln_IdMigracion18 := NAF47_TNET.TRANSA_ID.MIGRA_CG( Lv_EmpresaDestino );
                    else
                      l_migra_arcgae.ID_MIGRACION := NAF47_TNET.TRANSA_ID.MIGRA_CG( v_no_cia );
                    end if;
                     
                    --
                    Lr_MigraDocumentoAsociado.MIGRACION_ID   := l_migra_arcgae.ID_MIGRACION;
                    Lr_MigraDocumentoAsociado.TIPO_MIGRACION := 'CG';
                    --
                    l_migra_arcgae.ID_FORMA_PAGO          := lr_detalle_pago.ID_FORMA_PAGO;
                    l_migra_arcgae.ID_OFICINA_FACTURACION := lr_detalle_pago.OFICINA_ID;
                    --
                    l_migra_arcgae.NO_CIA           := v_no_cia;
                    l_migra_arcgae.ANO              := l_anio;
                    l_migra_arcgae.MES              := l_mes;
                    l_migra_arcgae.NO_ASIENTO       := FNKG_CONTABILIZAR_PAGO_MANUAL.GENERA_NO_DOCU_ASIENTO(
                                                                                                    r_plantilla_contable_cab.FORMATO_NO_DOCU_ASIENTO,
                                                                                                    lr_detalle_pago.ID_PAGO_DET, lr_detalle_pago );
                    l_migra_arcgae.IMPRESO          := 'N';
                    l_migra_arcgae.FECHA            := lr_detalle_pago.FE_CREACION;
                    l_migra_arcgae.DESCRI1          := GENERA_COMENTARIO(lr_detalle_pago, l_migra_arcgae.NO_ASIENTO , r_plantilla_contable_cab.FORMATO_GLOSA,null,null);
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
                      --
                      NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAE(l_migra_arcgae,l_MsnError);
                      --
                      IF nvl(Lv_BanderaReplicar,'N') = 'S' AND v_no_cia = Lv_EmpresaOrigen THEN
                        declare
                           Ln_IdOficina DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%type;
                          begin
                            select id_oficina INTO Ln_IdOficina
                              from DB_COMERCIAL.INFO_OFICINA_GRUPO b
                             where b.NOMBRE_OFICINA = (select replace(A.NOMBRE_OFICINA, 'ECUANET', 'MEGADATOS')
                                                         from DB_COMERCIAL.INFO_OFICINA_GRUPO a
                                                        where a.id_oficina = lr_detalle_pago.OFICINA_ID);
                         
                             l_migra_arcgae.ID_OFICINA_FACTURACION := Ln_IdOficina;
                             l_migra_arcgae.NO_CIA           := Lv_EmpresaDestino;
                             l_migra_arcgae.ID_MIGRACION := Ln_IdMigracion18;
                             
                             NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAE(l_migra_arcgae,l_MsnError);
                             
                             l_migra_arcgae.ID_MIGRACION     := Ln_IdMigracion33;
                             l_migra_arcgae.NO_CIA            := v_no_cia;
                             l_migra_arcgae.ID_OFICINA_FACTURACION := lr_detalle_pago.OFICINA_ID;
                          end;
                        
                      END IF;
                    ELSE
                      --
                      raise_application_error( -20006, 'No se realiza proceso contable, faltan datos para crear asiento. ID_PAGO_DET('
                                                       || v_pago_det_id || '), ID_EMPRESA(' || v_no_cia || ')' );
                      --
                    END IF;
                    --
                    --
                    IF l_MsnError IS NOT NULL THEN
                      --
                      raise_application_error( -20001, 'Error al insertar asiento en MIGRA_ARCGAE. ID_PAGO_DET(' || v_pago_det_id || '), '
                                                       || 'EMPRESA_ID(' || v_no_cia || ') : '||l_MsnError );
                      --
                    END IF;
            ELSE
                raise_application_error( -20005, 'No se realiza proceso contable, no se encontro plantilla' );
            END IF;

            msg_ret:='1500';

            --CREA DETALLES DEL ASIENTO - INSERTA DEBITO Y CREDITO
            CREA_DEBITO_CREDITO(r_plantilla_contable_cab, lr_detalle_pago, l_migra_arckmm, l_migra_arcgae, l_msn_debito_credito, Ln_IdMigracion18);

            IF l_msn_debito_credito='OK' THEN
                dbms_output.put_line('OK INGRESO DETALLES');
            ELSE
                dbms_output.put_line('ERROR INGRESO DETALLES');
                raise_application_error( -20006,  l_msn_debito_credito);
            END IF;
            --
          --
          MARCA_CONTABILIZADO_PAGO(lr_detalle_pago.ID_PAGO_DET,lr_detalle_pago.PAGO_ID, lr_detalle_pago.ESTADO_PAGO);
          --
          --
          IF Lr_MigraDocumentoAsociado.MIGRACION_ID IS NOT NULL AND Lr_MigraDocumentoAsociado.MIGRACION_ID > 0 THEN
            --
            msg_ret := NULL;
            --
            NAF47_TNET.GEK_MIGRACION.P_PROCESA_MIGRA_DOC_ASOCIADO(Lr_MigraDocumentoAsociado, 'I', msg_ret);
            
            if nvl(Lv_BanderaReplicar,'N') = 'S' AND v_no_cia = Lv_EmpresaOrigen then
              Lr_MigraDocumentoAsociado.MIGRACION_ID := Ln_IdMigracion18;
              Lr_MigraDocumentoAsociado.NO_CIA := Lv_EmpresaDestino;
              
              NAF47_TNET.GEK_MIGRACION.P_PROCESA_MIGRA_DOC_ASOCIADO(Lr_MigraDocumentoAsociado, 'I', msg_ret);
              
              Lr_MigraDocumentoAsociado.MIGRACION_ID := Ln_IdMigracion33;
              Lr_MigraDocumentoAsociado.NO_CIA := v_no_cia;
            end if;
            
            --
            IF msg_ret IS NOT NULL THEN
              --
              raise_application_error( -20010, 'Error al insertar la relaci�n del documento migrado en la tabla MIGRA_DOCUMENTO_ASOCIADO. ' ||
                                               ' DETALLE_PAGO ( ' || lr_detalle_pago.ID_PAGO_DET || '). MENSAJE ERROR NAF (' || msg_ret || ').');
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
        END IF;

    ELSE

        raise_application_error( -20007,  'Pago ya fue contabilizado anteriormente o no existe');

    END IF;

    CLOSE c_pagos;

    msg_ret:='Proceso OK';
    --
    --
    COMMIT;
    --
    --
  EXCEPTION
    WHEN OTHERS THEN
      --
      msg_ret := msg_ret || ' : ' || DBMS_UTILITY.FORMAT_ERROR_STACK;
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                            'FNKG_CONTABILIZAR_PAGO_MANUAL.PROCESAR_PAGO_ANTICIPO_MANUAL',
                                            msg_ret,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
      --
      ROLLBACK;
      --
  END PROCESAR_PAGO_ANTICIPO_MANUAL;





END FNKG_CONTABILIZAR_PAGO_MANUAL;
/