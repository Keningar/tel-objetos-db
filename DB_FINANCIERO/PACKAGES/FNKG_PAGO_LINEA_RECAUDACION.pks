CREATE EDITIONABLE PACKAGE               FNKG_PAGO_LINEA_RECAUDACION AS

  /*
  * Documentaci�n para TYPE 'TypeDetalleRecaudacion'.
  * Tipo de datos para procesar contabilidad pagos por recaudaci�n.
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.0 04-01-2018
  */
  Type TypeDetalleRecaudacion IS RECORD(
        ID_PAGO_DET                DB_FINANCIERO.INFO_PAGO_DET.ID_PAGO_DET%TYPE,
        FORMA_PAGO                 DB_GENERAL.ADMI_FORMA_PAGO.DESCRIPCION_FORMA_PAGO%TYPE,
        CODIGO_FORMA_PAGO          DB_GENERAL.ADMI_FORMA_PAGO.CODIGO_FORMA_PAGO%TYPE,
        MONTO                      DB_FINANCIERO.INFO_PAGO_DET.VALOR_PAGO%TYPE,
        FE_CREACION                DB_FINANCIERO.INFO_PAGO_DET.FE_CREACION%TYPE,
        NUMERO_PAGO                DB_FINANCIERO.INFO_PAGO_CAB.NUMERO_PAGO%TYPE,
        NUMERO_CUENTA_BANCO        DB_FINANCIERO.INFO_PAGO_DET.NUMERO_CUENTA_BANCO%TYPE,
        LOGIN                      DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
        USR_CREACION               DB_FINANCIERO.INFO_PAGO_DET.USR_CREACION%TYPE,
        OFICINA                    DB_COMERCIAL.INFO_OFICINA_GRUPO.NOMBRE_OFICINA%TYPE,
        CUENTA_CONTABLE_ID         DB_FINANCIERO.INFO_PAGO_DET.CUENTA_CONTABLE_ID%TYPE,
        NUMERO_REFERENCIA          DB_FINANCIERO.INFO_PAGO_DET.NUMERO_REFERENCIA%TYPE,
        OFICINA_ID                 DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
        PREFIJO                    DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
        TIPO_DOC                   DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
        PAGO_ID                    DB_FINANCIERO.INFO_PAGO_DET.PAGO_ID%TYPE,
        ID_FORMA_PAGO              DB_GENERAL.ADMI_FORMA_PAGO.ID_FORMA_PAGO%TYPE,
        TIPO_DOCUMENTO_ID          DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.ID_TIPO_DOCUMENTO%TYPE,
        COD_EMPRESA                DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
        FE_DEPOSITO                DB_FINANCIERO.INFO_PAGO_DET.FE_DEPOSITO%TYPE,
        PUNTO_ID                   DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
        ESTADO_PAGO                DB_FINANCIERO.INFO_PAGO_CAB.ESTADO_PAGO%TYPE,
        MONTO_ANTICIPOS            NUMBER,
        BANCO_TIPO_CUENTA_ID       DB_GENERAL.ADMI_BANCO_TIPO_CUENTA.ID_BANCO_TIPO_CUENTA%TYPE
  );

  /*
  * Documentaci�n para PROCEDURE 'P_CONTABILIZAR'.
  * Procedimiento que permigre generar contabilizaci�n de Pagos en Linea y recaudaciones MD
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.0 06-01-2018
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.1 13-09-2018 - Se modifica para cambiar contabilizaci�n sumarizada a detallada
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.2 27-09-2018 - Se modifica filtrar fecha ultima modificaci�n y no por fecha creaci�n de tabla pago en Linea
  *
  * @Param varchar2 Pv_NoCia        IN  Empresa que procesa contabilizaci�n
  * @Param varchar2 Pv_Fecha        IN  Fecha a procesar
  * @Param varchar2 Pv_MensajeError OUT Retorna mensaje de error
  */
  PROCEDURE P_CONTABILIZAR ( Pv_NoCia         IN VARCHAR2,
                             Pv_Fecha         IN VARCHAR2,
                             Pv_MensajeError  IN OUT VARCHAR2);

  /*
  * Documentaci�n para PROCEDURE 'P_CONTABILIZAR_ASIGNA_ANT_PTO'.
  * Procedimiento que permigre generar contabilizaci�n de asignaci�n de punto cliente a anticipos sin cliente.
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.0 06-01-2018

  * @Param varchar2 Pv_NoCia        IN  Empresa que procesa contabilizaci�n
  * @Param number   Pn_IdPagoCab    IN  C�digo de pago a procesar
  * @Param varchar2 Pv_MensajeError OUT Retorna mensaje de error
  */
  PROCEDURE P_CONTABILIZAR_ASIGNA_ANT_PTO ( Pv_NoCia        IN VARCHAR2,
                                            Pn_IdPagoCab    IN NUMBER,
                                            Pv_MensajeError IN OUT VARCHAR2);

END FNKG_PAGO_LINEA_RECAUDACION;
/

CREATE EDITIONABLE PACKAGE BODY               FNKG_PAGO_LINEA_RECAUDACION AS
  --
  Gv_NombreParametro        DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'VALIDACIONES_PROCESOS_CONTABLES';
  Gv_NombreProceso          DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.NOMBRE_PAQUETE_SQL%TYPE := 'FNKG_PAGO_LINEA_RECAUDACION';
  Gv_EstadoAtivo            DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE := 'Activo';
  Gv_ParamEstadoPago        DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE := 'ESTADO_PAGO';
  Gv_ParamEstCruceAntSinCli DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE := 'ESTADO_ANTICIPO_SIN_CLIENTE';
  Gv_ParamTipoDoc           DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE := 'CODIGO_TIPO_DOCUMENTO';
  Gv_ParamTipoDocCruce      DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE := 'TIPO_DOC_CRUCE_CLIENTE';
  
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
  --
  /*
  * Documentaci�n para PROCEDIMIENTO P_CADENA_ARREGLO
  * Funcion que divide en cadenas segun caracter de division
  * @Param in varchar2     Pv_Cadena (cadena a dividir)
  * @Param in varchar2     Pv_Caracter (cadena de division)
  * @Param out TypeArreglo Pr_Arreglo (arreglo con cadena dividida)
  *
  * Author: Luis Lindao <llindao@telconet.ec>
  * version: 1.0
  * Fecha 01/01/2018
  *
  * Author: Jimmy Gilces <jgilces@telconet.ec>
  */
  PROCEDURE P_CADENA_ARREGLO ( Pv_Cadena   IN VARCHAR2,
                               Pv_Caracter IN VARCHAR2,
                               Pr_Arreglo  OUT DB_FINANCIERO.FNKG_CONTABILIZAR_PAGO_MANUAL.TypeArreglo )  IS
    Ln_Idx number := 0;
  BEGIN
    FOR CURRENT_ROW IN ( WITH TEST AS (SELECT Pv_Cadena FROM DUAL)
                         SELECT regexp_substr(Pv_Cadena, '[^'||Pv_Caracter||']+', 1, ROWNUM) SPLIT
                         FROM TEST
                         CONNECT BY LEVEL <= LENGTH (regexp_replace(Pv_Cadena, '[^'||Pv_Caracter||']+'))  + 1 ) LOOP
      Ln_Idx := Ln_Idx + 1;
      Pr_Arreglo(Pr_Arreglo.COUNT) := CURRENT_ROW.SPLIT;
    END LOOP;
  END P_CADENA_ARREGLO;

  --
  /**
  * Documentacion para la Funci�n F_GENERA_COMENTARIO
  * Procedimiento que genera comentario para registro de asiento en repositorio de migraci�n
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.0 04-01-2018
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.1 13-09-2018 - Se modifica para agregar configuraci�n de campos para conceptos documentos MD
  *
  * @param Pr_DetallePago     IN DB_FINANCIERO.FNKG_PAGO_LINEA_RECAUDACION.TypeDetalleRecaudacion recibe variable registro detalle de pago
  * @param Pv_CadenaAdicional IN VARCHAR2      recibe cadena a procesar
  * @param Pv_MensajeError    IN OUT VARCHAR2  retorna mensaje de errores
  */
  FUNCTION F_GENERA_COMENTARIO ( Pr_DetallePago     IN DB_FINANCIERO.FNKG_PAGO_LINEA_RECAUDACION.TypeDetalleRecaudacion,
                                 Pv_CadenaAdicional IN VARCHAR2,
                                 Pv_Formato         IN VARCHAR2)
                               RETURN VARCHAR2 IS

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
    WHERE IPC.ID_PAGO = Pr_DetallePago.PAGO_ID
    AND IPER.PERSONA_ID = P.ID_PERSONA
    AND IP.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
    AND IPC.ID_PAGO = IPD.PAGO_ID
    AND IPC.PUNTO_ID = IP.ID_PUNTO;
    --
    Lr_DatoAdicional C_DATOS_ADICIONALES%ROWTYPE := NULL;
    Lv_Comentario    varchar2(800):='';
    Lt_Formato       DB_FINANCIERO.FNKG_CONTABILIZAR_PAGO_MANUAL.TypeArreglo;
    --
  BEGIN
      -- se convierte la cadena en arreglo
      P_CADENA_ARREGLO(Pv_Formato,'|',Lt_Formato);

      FOR i IN 0..Lt_Formato.count - 1 loop
        --
        IF Lt_Formato(i) IN ('comentario_pago', 'nombre_cliente','comentario_det') AND Lr_DatoAdicional.Id_Pago IS NULL THEN
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
                         
        IF (Lt_Formato(i) = 'numero_referencia') THEN
                             
           Lv_Comentario := Lv_Comentario || Pr_DetallePago.NUMERO_REFERENCIA;
                        
        ELSIF (Lt_Formato(i) = 'comentario_pago') THEN
                             
           Lv_Comentario := Lv_Comentario || Lr_DatoAdicional.COMENTARIO_PAGO;

        ELSIF (Lt_Formato(i) = 'nombre_cliente') THEN
                             
           Lv_Comentario := Lv_Comentario || Lr_DatoAdicional.NOMBRE_CLIENTE;

        ELSIF (Lt_Formato(i) = 'comentario_det') THEN
                             
           Lv_Comentario := Lv_Comentario || Lr_DatoAdicional.COMENTARIO_DETALLE_PAGO;

        ELSIF (Lt_Formato(i) = 'pag_fe_creacion') THEN

           Lv_Comentario := Lv_Comentario || TO_CHAR(Pr_DetallePago.FE_CREACION,'dd/mm/yyyy');

        ELSIF (Lt_Formato(i) = 'numero_pago') THEN

           Lv_Comentario := Lv_Comentario || Pr_DetallePago.NUMERO_PAGO;

        ELSIF (Lt_Formato(i) = 'no_asiento') THEN

           Lv_Comentario := Lv_Comentario || Pv_CadenaAdicional;

        ELSIF (Lt_Formato(i) = 'nombre_forma_pago') THEN

           Lv_Comentario := Lv_Comentario || Pr_DetallePago.FORMA_PAGO;

        ELSIF (Lt_Formato(i) = 'codigo_tipo_documento') THEN

           Lv_Comentario := Lv_Comentario || Pr_DetallePago.TIPO_DOC;

        ELSIF (Lt_Formato(i) = 'nombre_oficina') THEN

           Lv_Comentario := Lv_Comentario || Pr_DetallePago.OFICINA;

        ELSIF (Lt_Formato(i) = 'numero_cuenta_banco') THEN

           Lv_Comentario := Lv_Comentario || Pr_DetallePago.NUMERO_CUENTA_BANCO;

        ELSIF (Lt_Formato(i) = 'login') THEN

           Lv_Comentario := Lv_Comentario || Pr_DetallePago.LOGIN;

        ELSIF (Lt_Formato(i) = 'fe_actual') THEN

           Lv_Comentario := Lv_Comentario || TO_CHAR(SYSTIMESTAMP,'dd/mm/yyyy');

        ELSIF (Lt_Formato(i) = 'fecha_deposito') THEN

           Lv_Comentario := Lv_Comentario || TO_CHAR(Pr_DetallePago.FE_DEPOSITO,'dd/mm/yyyy');

        ELSIF (Lt_Formato(i) = 'longitud_500') THEN

           Lv_Comentario:=SUBSTR(Lv_Comentario,1,500);

        ELSIF (Lt_Formato(i) = 'longitud_100') THEN

           Lv_Comentario:=SUBSTR(Lv_Comentario,1,100);

        ELSIF (Lt_Formato(i) = 'longitud_250') THEN

           Lv_Comentario:=SUBSTR(Lv_Comentario,1,250);

        ELSIF (Lt_Formato(i) = 'longitud_255') THEN

           Lv_Comentario:=SUBSTR(Lv_Comentario,1,255);

        ELSIF (Lt_Formato(i) = 'longitud_240') THEN

           Lv_Comentario:=SUBSTR(Lv_Comentario,1,240);

        ELSE

           Lv_Comentario := Lv_Comentario || Lt_Formato(i);

        END IF;

      END LOOP;

      RETURN Lv_Comentario;

  END F_GENERA_COMENTARIO;

  /*
  * Documentaci�n para FUNCION 'GENERA_NO_DOCU_ASIENTO'.
  * FUNCION QUE GENERA EL NUMERO DE DOCUMENTO O EL NUMERO DE ASIENTO PARA MIGRA_ARCKMM o MIGRA_ARCGAE respectivamente
  * @author Andres Montero amontero@telconet.ec
  * @version 1.0
  * @since 17/03/2016
  * @Param varchar2                                       Pv_Formato (FORMATO con el que se genera el numero)
  * @Param FNKG_TRANSACTION_CONTABILIZAR.TypeDetallePagos Pr_DetallePago (arreglo con los datos del pago)
  * @return  VARCHAR2 (NUMERO GENERADO)
  */
  FUNCTION P_GENERA_NO_DOCU_ASIENTO ( Pv_Formato     IN VARCHAR2,
                                      Pn_IdPago      IN NUMBER,
                                      Pr_DetallePago IN TypeDetalleRecaudacion
                                    ) RETURN VARCHAR2 IS

    Lv_NumGenerado VARCHAR2(30):='';
    Pt_Formato DB_FINANCIERO.FNKG_CONTABILIZAR_PAGO_MANUAL.TypeArreglo;
    Pt_Fecha   DB_FINANCIERO.FNKG_CONTABILIZAR_PAGO_MANUAL.TypeArreglo;

  BEGIN

    IF Pv_Formato = 'id' THEN

        Lv_NumGenerado := Pn_IdPago;

    ELSE

      P_CADENA_ARREGLO(Pv_Formato,'|',Pt_Formato);

      FOR i IN 0..Pt_Formato.count - 1 loop
        --
        IF (Pt_Formato(i) = 'id') THEN
          Lv_NumGenerado := Lv_NumGenerado || Pn_IdPago;

        ELSIF (Pt_Formato(i) = 'id_oficina') THEN
          Lv_NumGenerado := Lv_NumGenerado || Pr_DetallePago.OFICINA_ID;

        ELSIF (Pt_Formato(i) = 'anio_fe_emision') THEN
          P_CADENA_ARREGLO(TO_CHAR(Pr_DetallePago.FE_CREACION,'YYYY-MM-DD'),'-',Pt_Fecha);
          Lv_NumGenerado:=Lv_NumGenerado||Pt_Fecha(0);

        ELSIF (Pt_Formato(i) = 'anio2_fe_emision') THEN
          P_CADENA_ARREGLO(TO_CHAR(Pr_DetallePago.FE_CREACION,'YY-MM-DD'),'-',Pt_Fecha);
          Lv_NumGenerado:=Lv_NumGenerado||Pt_Fecha(0);

        ELSIF (Pt_Formato(i) = 'mes_fe_emision') THEN
          P_CADENA_ARREGLO(TO_CHAR(Pr_DetallePago.FE_CREACION,'YYYY-MM-DD'),'-',Pt_Fecha);
          Lv_NumGenerado:=Lv_NumGenerado||Pt_Fecha(1);

        ELSIF (Pt_Formato(i) = 'dia_fe_emision') THEN
          P_CADENA_ARREGLO(TO_CHAR(Pr_DetallePago.FE_CREACION,'YYYY-MM-DD'),'-',Pt_Fecha);
          Lv_NumGenerado:=Lv_NumGenerado||Pt_Fecha(2);

        ELSIF (Pt_Formato(i) = 'hora_actual') THEN
          Lv_NumGenerado:=Lv_NumGenerado||TO_CHAR(SYSTIMESTAMP,'HH24MISS');

        ELSE
          Lv_NumGenerado:=Lv_NumGenerado||Pt_Formato(i);
        END IF;
      END LOOP;
    END IF;
    --
    RETURN Lv_NumGenerado;
    --
  END;

  /**
  * Documentacion para el procedimiento P_CREA_DEBITO_CREDITO
  * Procedimiento que genera lineas detalle contable
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.0 04-01-2018
  *
  * @param Pr_DetallePago     IN DB_FINANCIERO.FNKG_PAGO_LINEA_RECAUDACION.TypeDetalleRecaudacion recibe variable registro detalle de pago
  * @param Pv_CadenaAdicional IN VARCHAR2      recibe cadena a procesar
  * @param Pv_MensajeError    IN OUT VARCHAR2  retorna mensaje de errores
  */
PROCEDURE P_CREA_DEBITO_CREDITO ( Pr_CabPlantillaCon IN DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableCab,
                                  Pr_DetallePago     IN DB_FINANCIERO.FNKG_PAGO_LINEA_RECAUDACION.TypeDetalleRecaudacion,
                                  Pr_MigraArckmm     IN NAF47_TNET.MIGRA_ARCKMM%ROWTYPE,
                                  Pr_MigraArcgae     IN NAF47_TNET.MIGRA_ARCGAE%ROWTYPE,
                                  Pv_MensajeError    IN OUT VARCHAR2,
                                  Pv_IdMigracion18 IN NAF47_TNET.MIGRA_ARCGAE.ID_MIGRACION%TYPE DEFAULT 0) IS

    Lc_DetPlantillaCon    SYS_REFCURSOR ;
    Lr_DetPlantillaCon    DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableDet;
    Lr_CuentaContable     DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.TypeCuentaContable;
    Lv_CuentaContable     DB_FINANCIERO.ADMI_CUENTA_CONTABLE.CUENTA%TYPE := NULL;
    Lv_ValorCampoRef      DB_FINANCIERO.ADMI_CUENTA_CONTABLE.VALOR_CAMPO_REFERENCIAL%TYPE := NULL;
    Lv_NombreCampoRef     DB_FINANCIERO.ADMI_CUENTA_CONTABLE.CAMPO_REFERENCIAL%TYPE := NULL;
    Ln_ValorTipo          NUMBER(1);
    Lr_CuentaContableTipo DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.TypeCuentaContablePorTipo;
    Lr_MigraArckml        NAF47_TNET.MIGRA_ARCKML%ROWTYPE;
    Lr_MigraArcgal        NAF47_TNET.MIGRA_ARCGAL%ROWTYPE;
    Lrf_GetAdmiParametrosDet SYS_REFCURSOR;
    Lr_GetAdmiParametrosDet  DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
    
    Lv_EmpresaOrigen db_general.admi_parametro_det.valor2%type;
    Lv_EmpresaDestino db_general.admi_parametro_det.valor2%type;
    Lv_BanderaReplicar db_general.admi_parametro_det.valor2%type;

  BEGIN
    
  Lv_EmpresaOrigen := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'EMPRESA_ORIGEN');
      Lv_EmpresaDestino := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'EMPRESA_DESTINO');
      Lv_BanderaReplicar := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'APLICA_REPLICA_MIGRACION');
    
    -- se recupera detalle de plantilla
    Lc_DetPlantillaCon := DB_FINANCIERO.FNKG_CONTABILIZAR_PAGO_MANUAL.GET_PLANTILLA_CONTABLE_DET(Pr_CabPlantillaCon.ID_PLANTILLA_CONTABLE_CAB);
    --
    LOOP
      FETCH Lc_DetPlantillaCon INTO Lr_DetPlantillaCon;
      EXIT WHEN Lc_DetPlantillaCon%NOTFOUND;
      --
      -- se valida el tipo de cuenta cntable
      IF Lr_DetPlantillaCon.TIPO_CUENTA_CONTABLE IN ( 'BANCOS', 'MESES_ANTERIORES') THEN
        --
        Lr_CuentaContable := DB_FINANCIERO.FNKG_CONTABILIZAR_PAGO_MANUAL.GET_CUENTA_CONTABLE(Pr_DetallePago.CUENTA_CONTABLE_ID);
        Lv_CuentaContable:= Lr_CuentaContable.CUENTA;
        --
      ELSE
        IF Lr_DetPlantillaCon.TIPO_CUENTA_CONTABLE IN ('FORMA PAGO','RECAUDACION_SIN_SOPORTE') THEN
          --
          Lv_ValorCampoRef  := Pr_DetallePago.ID_FORMA_PAGO;
          Lv_NombreCampoRef := 'ID_FORMA_PAGO';
          --
        ELSIF Lr_DetPlantillaCon.TIPO_CUENTA_CONTABLE = 'BANCOS DEBITOS MD' THEN
          Lv_ValorCampoRef  := Pr_DetallePago.BANCO_TIPO_CUENTA_ID;
          Lv_NombreCampoRef := 'ID_BANCO_TIPO_CUENTA';
        --
        ELSE
          Lv_ValorCampoRef  := Pr_DetallePago.OFICINA_ID;
          Lv_NombreCampoRef := 'ID_OFICINA';
        END IF;
        --
        Lr_CuentaContableTipo := DB_FINANCIERO.FNKG_CONTABILIZAR_PAGO_MANUAL.GET_CUENTA_CONTABLE_POR_TIPO(
                                  Lv_ValorCampoRef,
                                  Lv_NombreCampoRef,
                                  Lr_DetPlantillaCon.TIPO_CUENTA_CONTABLE_ID,
                                  Pr_DetallePago.COD_EMPRESA);
        Lv_CuentaContable := Lr_CuentaContableTipo.CUENTA;
        --
      END IF;
      --
      IF Lr_DetPlantillaCon.POSICION = 'C' THEN
        Ln_ValorTipo:= -1;
      ELSE
        Ln_ValorTipo := 1;
      END IF;
      --
      IF Lv_CuentaContable is not null THEN
        --
        IF Pr_CabPlantillaCon.TABLA_DETALLE = 'MIGRA_ARCKML' THEN
          --
          Lr_MigraArckml .MIGRACION_ID := Pr_MigraArckmm.ID_MIGRACION;
          Lr_MigraArckml.NO_CIA       := Pr_MigraArckmm.NO_CIA;
          Lr_MigraArckml.PROCEDENCIA  := 'C';
          Lr_MigraArckml.TIPO_DOC     := Pr_MigraArckmm.TIPO_DOC;
          Lr_MigraArckml.NO_DOCU      := Pr_MigraArckmm.NO_DOCU;
          Lr_MigraArckml.COD_CONT     := Lv_CuentaContable;
          Lr_MigraArckml.CENTRO_COSTO := '000000000';
          Lr_MigraArckml.TIPO_CAMBIO  := 1;
          Lr_MigraArckml.MONEDA       := 'P';
          Lr_MigraArckml.MODIFICABLE  := 'N';
          Lr_MigraArckml.ANO          := Pr_MigraArckmm.ANO;
          Lr_MigraArckml.MES          := Pr_MigraArckmm.MES;
          Lr_MigraArckml.COD_DIARIO   := Pr_MigraArckmm.COD_DIARIO;
          Lr_MigraArckml.GLOSA        := F_GENERA_COMENTARIO( Pr_DetallePago,'',Lr_DetPlantillaCon.FORMATO_GLOSA);
          Lr_MigraArckml.TIPO_MOV     := Lr_DetPlantillaCon.POSICION;
          Lr_MigraArckml.MONTO        := 0;
          Lr_MigraArckml.MONTO_DOl    := 0;
          Lr_MigraArckml.MONTO_DC     := 0;

          --SI EL PAGO GENERO ANTICIPO CREA EL REGISTRO PARA ANTICIPOS
          IF (Lr_DetPlantillaCon.TIPO_CUENTA_CONTABLE='ANTICIPO CLIENTES') THEN
              IF ( Pr_DetallePago.MONTO_ANTICIPOS>0 AND Pr_DetallePago.TIPO_DOC='PAG') THEN
                  Lr_MigraArckml.MONTO          := Pr_DetallePago.MONTO_ANTICIPOS;
                  Lr_MigraArckml.MONTO_DOl      := Pr_DetallePago.MONTO_ANTICIPOS;
                  Lr_MigraArckml.MONTO_DC       := Pr_DetallePago.MONTO_ANTICIPOS;
                  IF (Lr_MigraArckml.MONTO <> 0) THEN
                    NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKML(Lr_MigraArckml, Pv_MensajeError);
                    
                    IF nvl(Lv_BanderaReplicar,'N') = 'S' AND Pr_MigraArckmm.NO_CIA = Lv_EmpresaOrigen THEN
                      Lr_MigraArckml.MIGRACION_ID := Pv_IdMigracion18;
                      Lr_MigraArckml.NO_CIA       := Lv_EmpresaDestino;
                            
                      NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKML(Lr_MigraArckml, Pv_MensajeError);
                            
                      Lr_MigraArckml.MIGRACION_ID := Pr_MigraArckmm.ID_MIGRACION;
                      Lr_MigraArckml.NO_CIA       := Pr_MigraArckmm.NO_CIA;
                    END IF;
                  END IF;
              ELSIF (Pr_DetallePago.TIPO_DOC IN ('ANT','ANTS')) THEN
                  Lr_MigraArckml.MONTO          := Pr_DetallePago.MONTO;
                  Lr_MigraArckml.MONTO_DOl      := Pr_DetallePago.MONTO;
                  Lr_MigraArckml.MONTO_DC       := Pr_DetallePago.MONTO;
                  IF (Lr_MigraArckml.MONTO <> 0) THEN
                    NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKML(Lr_MigraArckml,Pv_MensajeError);
                    IF nvl(Lv_BanderaReplicar,'N') = 'S' AND Pr_MigraArckmm.NO_CIA = Lv_EmpresaOrigen THEN
                      Lr_MigraArckml.MIGRACION_ID := Pv_IdMigracion18;
                      Lr_MigraArckml.NO_CIA       := Lv_EmpresaDestino;
                            
                      NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKML(Lr_MigraArckml, Pv_MensajeError);
                            
                      Lr_MigraArckml.MIGRACION_ID := Pr_MigraArckmm.ID_MIGRACION;
                      Lr_MigraArckml.NO_CIA       := Pr_MigraArckmm.NO_CIA;
                    END IF;
                  END IF;
              END IF;
          ELSE
              IF (Lr_DetPlantillaCon.POSICION = 'C') THEN
                  Lr_MigraArckml.MONTO     := Pr_DetallePago.MONTO;
                  Lr_MigraArckml.MONTO_DOl := Pr_DetallePago.MONTO;
                  Lr_MigraArckml.MONTO_DC  := Pr_DetallePago.MONTO;
              ELSE
                  Lr_MigraArckml.MONTO     := Pr_DetallePago.MONTO + Pr_DetallePago.MONTO_ANTICIPOS;
                  Lr_MigraArckml.MONTO_DOl := Pr_DetallePago.MONTO + Pr_DetallePago.MONTO_ANTICIPOS;
                  Lr_MigraArckml.MONTO_DC  := Pr_DetallePago.MONTO + Pr_DetallePago.MONTO_ANTICIPOS;
              END IF;
              --INSERTA DEBITO O CREDITO DEL ASIENTO
              ----------------------------
              IF (Lr_MigraArckml.MONTO <> 0) THEN
                NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKML(Lr_MigraArckml,Pv_MensajeError);
                
                IF nvl(Lv_BanderaReplicar,'N') = 'S' AND Pr_MigraArckmm.NO_CIA = Lv_EmpresaOrigen THEN
                  Lr_MigraArckml.MIGRACION_ID := Pv_IdMigracion18;
                  Lr_MigraArckml.NO_CIA       := Lv_EmpresaDestino;
                        
                  NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKML(Lr_MigraArckml, Pv_MensajeError);
                        
                  Lr_MigraArckml.MIGRACION_ID := Pr_MigraArckmm.ID_MIGRACION;
                  Lr_MigraArckml.NO_CIA       := Pr_MigraArckmm.NO_CIA;
                END IF;
              END IF;
          END IF;

          IF Pv_MensajeError IS NOT NULL THEN
            DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR(
              'FNKG_PAGO_LINEA_RECAUDACION',
              'PROCESAR_PAGO_ANTICIPO_MANUAL',
              Pv_MensajeError);
            --
            raise_application_error( -20008, 'Error al insertar asiento tipo '|| Lr_DetPlantillaCon.POSICION ||' en MIGRA_ARCKML' );
            --
          END IF;


        ELSIF Pr_CabPlantillaCon.TABLA_DETALLE = 'MIGRA_ARCGAL' THEN
          --
          Lr_MigraArcgal.NO_CIA := Pr_MigraArcgae.NO_CIA;
          Lr_MigraArcgal.CUENTA := Lv_CuentaContable;
          Lr_MigraArcgal.Cc_1   := '000';
          Lr_MigraArcgal.Cc_2   := '000';
          Lr_MigraArcgal.Cc_3   := '000';
          --
          -- Tambien se valida si cuenta contable recuperar acepta centro de costos
          IF NAF47_TNET.CUENTA_CONTABLE.acepta_cc (Lr_MigraArcgal.NO_CIA, Lr_MigraArcgal.CUENTA) THEN
            -- si cuenta contable maneja centro de costo se busca en la parametrizacion
            --IF Lr_DocReversar.CODIGO_FORMA_PAGO = 'PROI' THEN
            --
            --BLOQUE QUE VERIFICA SI EXISTE LA OPCION EN LOS PARAMETROS PARA COLOCAR EL COSTO A LOS PAGOS CON PROVISION INCOBRABLE
            Lrf_GetAdmiParametrosDet := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET(
                                        'SHOW_OPCION_BY_EMPRESA',
                                        'Activo',
                                        'Activo',
                                        Pr_MigraArcgae.id_oficina_facturacion, --Lr_DocReversar.CODIGO_FORMA_PAGO,
                                                                                --'COSTO_PAGO_PROVISION_INCOBRABLE',
                                        Pr_MigraArcgae.no_cia,--Lr_DocReversar.COD_EMPRESA,
                                        NULL, --Lr_DocReversar.OFICINA_ID,
                                        NULL );
                --
            FETCH Lrf_GetAdmiParametrosDet INTO Lr_GetAdmiParametrosDet;
            CLOSE Lrf_GetAdmiParametrosDet;
            --
            -- se verifica que retorne valores
            IF Lr_GetAdmiParametrosDet.ID_PARAMETRO_DET IS NULL THEN
              --
              Pv_MensajeError := 'No se ha configurado Centro de costo para FormaPago: ' || Pr_MigraArcgae.id_forma_pago || ' y oficina: ' ||
                                  Pr_MigraArcgae.id_oficina_facturacion;
              --
              DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                                    'FNKG_CONTABILIZAR_PAGO_MANUAL.CREA_DEBITO_CREDITO',
                                                    Pv_MensajeError,
                                                    NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                                    SYSDATE,
                                                    NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
              --
              raise_application_error( -20007, Pv_MensajeError);
              --
            END IF;
                --
            Lr_MigraArcgal.Cc_1 := Lr_GetAdmiParametrosDet.VALOR3;
            Lr_MigraArcgal.Cc_2 := Lr_GetAdmiParametrosDet.VALOR4;
            Lr_MigraArcgal.Cc_3 := Lr_GetAdmiParametrosDet.VALOR5;
                --
          END IF;
          --
          --
          Lr_MigraArcgal.MIGRACION_ID           := Pr_MigraArcgae.ID_MIGRACION;
          Lr_MigraArcgal.ANO                    := Pr_MigraArcgae.ANO;
          Lr_MigraArcgal.MES                    := Pr_MigraArcgae.MES;
          Lr_MigraArcgal.NO_ASIENTO             := Pr_MigraArcgae.NO_ASIENTO;
          Lr_MigraArcgal.DESCRI                 := F_GENERA_COMENTARIO( Pr_DetallePago, Lr_MigraArcgal.NO_ASIENTO, Lr_DetPlantillaCon.FORMATO_GLOSA);
          Lr_MigraArcgal.COD_DIARIO             := Pr_MigraArcgae.COD_DIARIO;
          Lr_MigraArcgal.MONEDA                 := 'P';
          Lr_MigraArcgal.TIPO_CAMBIO            := 1;
          Lr_MigraArcgal.CENTRO_COSTO           := Lr_MigraArcgal.Cc_1 || Lr_MigraArcgal.Cc_2 || Lr_MigraArcgal.Cc_3;
          Lr_MigraArcgal.TIPO                   := 'D';
          Lr_MigraArcgal.LINEA_AJUSTE_PRECISION := 'N';
          Lr_MigraArcgal.MONTO                  := 0;
          Lr_MigraArcgal.MONTO_DOl              := 0;

          Lr_MigraArcgal.TIPO   := Lr_DetPlantillaCon.POSICION;

          --SI EL PAGO GENERO ANTICIPO CREA EL REGISTRO PARA ANTICIPOS
          IF(Lr_DetPlantillaCon.TIPO_CUENTA_CONTABLE='ANTICIPO CLIENTES') THEN
            IF (Pr_DetallePago.MONTO_ANTICIPOS>0  AND Pr_DetallePago.TIPO_DOC='PAG') THEN
              Lr_MigraArcgal.MONTO          := Pr_DetallePago.MONTO_ANTICIPOS * Ln_ValorTipo;
              Lr_MigraArcgal.MONTO_DOl      := Pr_DetallePago.MONTO_ANTICIPOS * Ln_ValorTipo;

              --INSERTA DEBITO O CREDITO DEL ASIENTO ANTICIPOS
              ----------------------------
              IF (Lr_MigraArcgal.MONTO <> 0) THEN
                Lr_MigraArcgal.No_Linea := nvl(Lr_MigraArcgal.No_Linea,0) + 1;
                NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAL(Lr_MigraArcgal,Pv_MensajeError);
                IF nvl(Lv_BanderaReplicar,'N') = 'S' AND Pr_MigraArcgae.NO_CIA = Lv_EmpresaOrigen then
                  Lr_MigraArcgal.MIGRACION_ID := Pv_IdMigracion18;
                  Lr_MigraArcgal .NO_CIA := Lv_EmpresaDestino;
                  
                  NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAL(Lr_MigraArcgal,Pv_MensajeError);
                  
                  Lr_MigraArcgal.MIGRACION_ID := Pr_MigraArcgae.ID_MIGRACION;
                  Lr_MigraArcgal .NO_CIA := Pr_MigraArcgae.NO_CIA;
                end if;
              END IF;

            ELSIF Pr_DetallePago.TIPO_DOC IN ('ANT','ANTS') THEN
              --
              Lr_MigraArcgal.MONTO     := Pr_DetallePago.MONTO * Ln_ValorTipo;
              Lr_MigraArcgal.MONTO_DOl := Pr_DetallePago.MONTO * Ln_ValorTipo;
              --
              IF Lr_MigraArcgal.MONTO <> 0 THEN
                --
                Lr_MigraArcgal.No_Linea := nvl(Lr_MigraArcgal.No_Linea,0) + 1;
                NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAL(Lr_MigraArcgal,Pv_MensajeError);
                IF nvl(Lv_BanderaReplicar,'N') = 'S' AND Pr_MigraArcgae.NO_CIA = Lv_EmpresaOrigen then
                  Lr_MigraArcgal.MIGRACION_ID := Pv_IdMigracion18;
                  Lr_MigraArcgal .NO_CIA := Lv_EmpresaDestino;
                  
                  NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAL(Lr_MigraArcgal,Pv_MensajeError);
                  
                  Lr_MigraArcgal.MIGRACION_ID := Pr_MigraArcgae.ID_MIGRACION;
                  Lr_MigraArcgal .NO_CIA := Pr_MigraArcgae.NO_CIA;
                end if;
                --
              ELSE
                --
                Lr_MigraArcgal.MONTO     := Pr_DetallePago.MONTO_ANTICIPOS * Ln_ValorTipo;
                Lr_MigraArcgal.MONTO_DOl := Pr_DetallePago.MONTO_ANTICIPOS * Ln_ValorTipo;
                --
                IF Lr_MigraArcgal.MONTO <> 0 THEN
                  --
                  Lr_MigraArcgal.No_Linea := nvl(Lr_MigraArcgal.No_Linea,0) + 1;
                  NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAL(Lr_MigraArcgal,Pv_MensajeError);
                  IF nvl(Lv_BanderaReplicar,'N') = 'S' AND Pr_MigraArcgae.NO_CIA = Lv_EmpresaOrigen then
                    Lr_MigraArcgal.MIGRACION_ID := Pv_IdMigracion18;
                    Lr_MigraArcgal .NO_CIA := Lv_EmpresaDestino;
                    
                    NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAL(Lr_MigraArcgal,Pv_MensajeError);
                    
                    Lr_MigraArcgal.MIGRACION_ID := Pr_MigraArcgae.ID_MIGRACION;
                    Lr_MigraArcgal .NO_CIA := Pr_MigraArcgae.NO_CIA;
                end if;
                  --
                END IF;
                --
              END IF;
                    --
            END IF;
          ELSE
            IF (Lr_DetPlantillaCon.POSICION = 'C') THEN
              --INSERTA DEBITO O CREDITO DEL ASIENTO
              Lr_MigraArcgal.MONTO     := Pr_DetallePago.MONTO * Ln_ValorTipo;
              Lr_MigraArcgal.MONTO_DOl := Pr_DetallePago.MONTO * Ln_ValorTipo;
            ELSE
              Lr_MigraArcgal.MONTO     := Pr_DetallePago.MONTO + Pr_DetallePago.MONTO_ANTICIPOS;
              Lr_MigraArcgal.MONTO_DOl := Pr_DetallePago.MONTO + Pr_DetallePago.MONTO_ANTICIPOS;
            END IF;
            --
            IF (Lr_MigraArcgal.MONTO <> 0) THEN
              Lr_MigraArcgal.No_Linea := nvl(Lr_MigraArcgal.No_Linea,0) + 1;
              NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAL(Lr_MigraArcgal,Pv_MensajeError);
              IF nvl(Lv_BanderaReplicar,'N') = 'S' AND Pr_MigraArcgae.NO_CIA = Lv_EmpresaOrigen then
                  Lr_MigraArcgal.MIGRACION_ID := Pv_IdMigracion18;
                  Lr_MigraArcgal .NO_CIA := Lv_EmpresaDestino;
                  
                  NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAL(Lr_MigraArcgal,Pv_MensajeError);
                  
                  Lr_MigraArcgal.MIGRACION_ID := Pr_MigraArcgae.ID_MIGRACION;
                  Lr_MigraArcgal .NO_CIA := Pr_MigraArcgae.NO_CIA;
                end if;
            END IF;
          END IF;

          IF Pv_MensajeError IS NOT NULL THEN
            DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNKG_CONTABILIZAR', 'PROCESAR_PAGO_ANTICIPO_MANUAL',Pv_MensajeError);
            raise_application_error( -20007, 'Error al insertar asiento tipo  '|| Lr_DetPlantillaCon.POSICION ||' en MIGRA_ARCGAL' );
          END IF;
        END IF;
      END IF;


    END LOOP;
    --
    CLOSE Lc_DetPlantillaCon;

  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en FNKG_PAGO_LINEA_RECAUDACION.P_CREA_DEBITO_CREDITO. '||SQLERRM;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL .INSERT_ERROR( 'Telcos+',
                                            'FNKG_PAGO_LINEA_RECAUDACION.P_CREA_DEBITO_CREDITO',
                                            Pv_MensajeError,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_CREA_DEBITO_CREDITO;

  PROCEDURE P_CONTABILIZAR ( Pv_NoCia         IN VARCHAR2,
                             Pv_Fecha         IN VARCHAR2,
                             Pv_MensajeError  IN OUT VARCHAR2) IS
    --
    CURSOR C_TIPO_PAGO_RECAUDACION IS
      --
      SELECT APD.ID_PARAMETRO_DET,
        APD.PARAMETRO_ID,
        APD.VALOR1 PARAMETRO_TIPO_DOC,
        APD.VALOR2 PREFIJO_TIPO_DOCUMENTO,
        APD.VALOR3 PREFIO_FORMA_PAGO,
        APD.VALOR4 TIPO_PROCESO,
        APD.VALOR5
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
        DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APC.ID_PARAMETRO    = APD.PARAMETRO_ID
      AND APC.ESTADO            = NVL(Gv_EstadoAtivo, APC.ESTADO )
      AND APD.ESTADO            = NVL(Gv_EstadoAtivo, APD.ESTADO )
      AND APC.NOMBRE_PARAMETRO  = NVL(Gv_NombreParametro, APC.NOMBRE_PARAMETRO )
      AND APD.DESCRIPCION       = NVL(Gv_NombreProceso, APD.DESCRIPCION )
      AND APD.VALOR1            = NVL(Gv_ParamTipoDoc, APD.VALOR1 )
      AND APD.EMPRESA_COD       = NVL(Pv_NoCia, APD.EMPRESA_COD )
      ORDER BY APD.VALOR3;

    --
    CURSOR C_RECAUDACIONES ( Cv_CodTipoDocFin VARCHAR2,
                             Cv_CodFormaPago  VARCHAR2) IS
      SELECT PD.ID_PAGO_DET,
        FP.DESCRIPCION_FORMA_PAGO FORMA_PAGO,
        FP.CODIGO_FORMA_PAGO CODIGO_FORMA_PAGO,
        PD.VALOR_PAGO MONTO,
        RD.FE_CREACION,
        P.NUMERO_PAGO,
        PD.NUMERO_CUENTA_BANCO,
        (SELECT LOGIN
         FROM DB_COMERCIAL.INFO_PUNTO PTO
         WHERE PTO.ID_PUNTO = P.PUNTO_ID ) LOGIN,
        RD.USR_CREACION,
        OFI.NOMBRE_OFICINA OFICINA,
        PD.CUENTA_CONTABLE_ID,
        PD.NUMERO_REFERENCIA,
        P.OFICINA_ID,
        EMP.PREFIJO,
        TDF.CODIGO_TIPO_DOCUMENTO TIPO_DOC,
        PD.PAGO_ID,
        PD.FORMA_PAGO_ID ID_FORMA_PAGO,
        P.TIPO_DOCUMENTO_ID,
        EMP.COD_EMPRESA,
        PD.FE_DEPOSITO,
        P.PUNTO_ID,
        P.ESTADO_PAGO,
        0 MONTO_ANTICIPOS,
        PD.BANCO_TIPO_CUENTA_ID
      FROM DB_FINANCIERO.INFO_PAGO_DET PD,
        DB_FINANCIERO.INFO_PAGO_CAB P,
        DB_FINANCIERO.INFO_RECAUDACION_DET RD,
        DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO TDF,
        DB_COMERCIAL.ADMI_FORMA_PAGO FP,
        DB_COMERCIAL.INFO_OFICINA_GRUPO OFI,
        DB_COMERCIAL.INFO_EMPRESA_GRUPO EMP
      WHERE PD.PAGO_ID = P.ID_PAGO
      AND P.RECAUDACION_DET_ID = RD.ID_RECAUDACION_DET
      AND P.TIPO_DOCUMENTO_ID = TDF.ID_TIPO_DOCUMENTO
      AND PD.FORMA_PAGO_ID = FP.ID_FORMA_PAGO
      AND P.OFICINA_ID = OFI.ID_OFICINA
      AND OFI.EMPRESA_ID = EMP.COD_EMPRESA
      AND P.EMPRESA_ID = Pv_NoCia
      AND TDF.CODIGO_TIPO_DOCUMENTO = Cv_CodTipoDocFin
      AND FP.CODIGO_FORMA_PAGO = Cv_CodFormaPago
      --
      AND RD.FE_CREACION >= TO_TIMESTAMP(Pv_Fecha||' 00:00:00', 'DD-MM-YYYY HH24:MI:SS')
      AND RD.FE_CREACION <= TO_TIMESTAMP(Pv_Fecha||' 23:59:59', 'DD-MM-YYYY HH24:MI:SS')
      --
      AND NOT EXISTS (SELECT NULL
                      FROM NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO MDA
                      WHERE MDA.DOCUMENTO_ORIGEN_ID = PD.ID_PAGO_DET
                      AND MDA.ESTADO = 'M'
                      AND MDA.TIPO_MIGRACION = 'CK')
      AND EXISTS (SELECT NULL
                  FROM DB_GENERAL.ADMI_PARAMETRO_DET APD,
                    DB_GENERAL.ADMI_PARAMETRO_CAB APC
                  WHERE APD.VALOR2 = P.ESTADO_PAGO
                  AND APD.EMPRESA_COD = P.EMPRESA_ID
                  AND APD.PARAMETRO_ID = APC.ID_PARAMETRO
                  AND APC.NOMBRE_PARAMETRO = Gv_NombreParametro
                  AND APC.ESTADO             = Gv_EstadoAtivo
                  AND APD.ESTADO             = Gv_EstadoAtivo
                  AND APD.DESCRIPCION        = Gv_NombreProceso
                  AND APD.VALOR1             = Gv_ParamEstadoPago
                  )
      UNION
      SELECT IPD.ID_PAGO_DET,
        AFP.DESCRIPCION_FORMA_PAGO FORMA_PAGO,
        AFP.CODIGO_FORMA_PAGO,
        IPD.VALOR_PAGO MONTO,
        IPL.FE_CREACION,
        IPC.NUMERO_PAGO,
        IPD.NUMERO_CUENTA_BANCO,
        (SELECT LOGIN
         FROM DB_COMERCIAL.INFO_PUNTO IP
         WHERE IP.ID_PUNTO = IPC.PUNTO_ID ) LOGIN,
        IPL.USR_CREACION,
        IOG.NOMBRE_OFICINA OFICINA,
        IPD.CUENTA_CONTABLE_ID,
        IPD.NUMERO_REFERENCIA,
        IPL.OFICINA_ID,
        IEG.PREFIJO,
        ATDF.CODIGO_TIPO_DOCUMENTO,
        IPD.PAGO_ID,
        AFP.ID_FORMA_PAGO,
        IPC.TIPO_DOCUMENTO_ID,
        IEG.COD_EMPRESA,
        IPD.FE_DEPOSITO,
        IPC.PUNTO_ID,
        IPC.ESTADO_PAGO,
        0 MONTO_ANTICIPOS,
        ACPL.BANCO_TIPO_CUENTA_ID
      FROM INFO_PAGO_LINEA IPL
        JOIN ADMI_CANAL_PAGO_LINEA ACPL ON ACPL.ID_CANAL_PAGO_LINEA = IPL.CANAL_PAGO_LINEA_ID
        JOIN INFO_PAGO_CAB IPC ON IPC.PAGO_LINEA_ID = IPL.ID_PAGO_LINEA
        JOIN INFO_PAGO_DET IPD ON IPD.PAGO_ID = IPC.ID_PAGO
        JOIN ADMI_FORMA_PAGO AFP ON AFP.ID_FORMA_PAGO = IPD.FORMA_PAGO_ID
        JOIN ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF ON ATDF.ID_TIPO_DOCUMENTO = IPC.TIPO_DOCUMENTO_ID
        JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO IOG ON IOG.ID_OFICINA = IPL.OFICINA_ID
        JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ON IEG.COD_EMPRESA = IPL.EMPRESA_ID
      WHERE IPL.EMPRESA_ID = Pv_NoCia
      AND IPL.FE_ULT_MOD >= TO_TIMESTAMP(Pv_Fecha||' 00:00:00', 'DD-MM-YYYY HH24:MI:SS')
      AND IPL.FE_ULT_MOD <= TO_TIMESTAMP(Pv_Fecha||' 23:59:59', 'DD-MM-YYYY HH24:MI:SS')
      AND IPL.ESTADO_PAGO_LINEA = 'Conciliado'
      AND ATDF.CODIGO_TIPO_DOCUMENTO = Cv_CodTipoDocFin
      AND AFP.CODIGO_FORMA_PAGO = Cv_CodFormaPago
      AND NOT EXISTS (SELECT NULL
                      FROM NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO MDA
                      WHERE MDA.DOCUMENTO_ORIGEN_ID = IPD.ID_PAGO_DET
                      AND MDA.ESTADO = 'M'
                      AND MDA.TIPO_MIGRACION = 'CK')
      AND EXISTS (SELECT NULL
                  FROM DB_GENERAL.ADMI_PARAMETRO_DET APD,
                    DB_GENERAL.ADMI_PARAMETRO_CAB APC
                  WHERE APD.PARAMETRO_ID = APC.ID_PARAMETRO
                  AND IPC.ESTADO_PAGO = APD.VALOR2
                  AND IPC.EMPRESA_ID = APD.EMPRESA_COD
                  AND APC.NOMBRE_PARAMETRO = Gv_NombreParametro
                  AND APC.ESTADO           = Gv_EstadoAtivo
                  AND APD.ESTADO           = Gv_EstadoAtivo
                  AND APD.DESCRIPCION      = Gv_NombreProceso
                  AND APD.VALOR1           = Gv_ParamEstadoPago);


    Le_Error         EXCEPTION;
    --
    Lr_CabPlantillaCon    DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableCab;
    Lr_CuentaContable     DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.TypeCuentaContable;
    Lr_DetallePago        DB_FINANCIERO.FNKG_PAGO_LINEA_RECAUDACION.TypeDetalleRecaudacion;
    --
    Lr_MigraArckmm      NAF47_TNET.MIGRA_ARCKMM%ROWTYPE;
    Lr_MigraArcgae      NAF47_TNET.MIGRA_ARCGAE%ROWTYPE;
    Lr_MigraDocAsociado NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO%ROWTYPE;
    --
    
    Ln_IdMigracion33 number;
    Ln_IdMigracion18 number;
    
    Lv_EmpresaOrigen db_general.admi_parametro_det.valor2%type;
    Lv_EmpresaDestino db_general.admi_parametro_det.valor2%type;
    Lv_BanderaReplicar db_general.admi_parametro_det.valor2%type;

  BEGIN
    Lv_EmpresaOrigen := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'EMPRESA_ORIGEN');
      Lv_EmpresaDestino := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'EMPRESA_DESTINO');
      Lv_BanderaReplicar := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'APLICA_REPLICA_MIGRACION');
      
    FOR Lr_TipoRecaudacion IN C_TIPO_PAGO_RECAUDACION LOOP

      IF Lr_TipoRecaudacion.Prefijo_Tipo_Documento IS NULL THEN
        Pv_MensajeError := 'No se ha definido prefijo Tipo Documento (Valor2) en Parametro: '||Gv_NombreParametro||', proceso: '||Gv_NombreProceso;
        RAISE Le_Error;
      ELSIF Lr_TipoRecaudacion.Prefio_Forma_Pago IS NULL THEN
        Pv_MensajeError := 'No se ha definido prefijo Forma de Pago (Valor3) en Parametro: '||Gv_NombreParametro||', proceso: '||Gv_NombreProceso;
        RAISE Le_Error;
      ELSIF Lr_TipoRecaudacion.Tipo_Proceso IS NULL THEN
        Pv_MensajeError := 'No se ha definido Tipo de Proceso (Valor4) en Parametro: '||Gv_NombreParametro||', proceso: '||Gv_NombreProceso;
        RAISE Le_Error;
      END IF;
      -- se inicializa variable registro migra arckmm
      Lr_MigraArckmm := null;

      -- se recuperan datos de la cabecera de plantilla con la que se va a trabajr.
      Lr_CabPlantillaCon := DB_FINANCIERO.FNKG_CONTABILIZAR_PAGO_MANUAL.GET_PLANTILLA_CONTABLE_CAB_COD( Pv_NoCia,
                                                                                                        Lr_TipoRecaudacion.Prefio_Forma_Pago,
                                                                                                        Lr_TipoRecaudacion.Prefijo_Tipo_Documento,
                                                                                                        Lr_TipoRecaudacion.Tipo_Proceso);
      --
      IF Lr_CabPlantillaCon.ID_PLANTILLA_CONTABLE_CAB IS NULL THEN
        Pv_MensajeError := 'No se ha definido Plantilla contable para documento '||Lr_TipoRecaudacion.Prefijo_Tipo_Documento||', forma pago: '||Lr_TipoRecaudacion.Prefio_Forma_Pago||' y tipo proceso: '||Lr_TipoRecaudacion.Tipo_Proceso;
        RAISE Le_Error;
      END IF;
      --
      FOR Lr_DetallePago IN  C_RECAUDACIONES ( Lr_TipoRecaudacion.Prefijo_Tipo_Documento,
                                               Lr_TipoRecaudacion.Prefio_Forma_Pago) LOOP
        --
        -- se inicializa variable registro documento asociado.
        Lr_MigraDocAsociado := NULL;
        Lr_MigraArckmm := NULL;

        IF Lr_DetallePago.CUENTA_CONTABLE_ID IS NOT NULL THEN
          -- se recupera informaci�n de cuenta bancaria
          Lr_CuentaContable := DB_FINANCIERO.FNKG_CONTABILIZAR_PAGO_MANUAL.GET_CUENTA_CONTABLE( Lr_DetallePago.CUENTA_CONTABLE_ID );

        ELSIF Lr_DetallePago.Banco_Tipo_Cuenta_Id IS NOT NULL THEN
          -- se recupera informaci�n de cuenta bancaria
          Lr_CuentaContable := FNKG_CONTABILIZAR_DEBITOS.F_GET_CUENTA_CONTABLE_POR_TIPO( Lr_DetallePago.Banco_Tipo_Cuenta_Id,
                                 'ID_BANCO_TIPO_CUENTA',
                                 'BANCOS DEBITOS MD',
                                 Pv_NoCia);
        END IF;

        -- se inicializan los campos a insertar
        Lr_MigraArckmm .No_Cia          := Pv_NoCia;
        Lr_MigraArckmm.No_Cta          := Lr_CuentaContable.NO_CTA;
        Lr_MigraArckmm.Tipo_Doc        := Lr_CabPlantillaCon.TIPO_DOC;
        Lr_MigraArckmm.Fecha           := TRUNC(Lr_DetallePago.Fe_Creacion);
        Lr_MigraArckmm.Ano             := TO_NUMBER(TO_CHAR(Lr_MigraArckmm.Fecha,'YYYY'));
        Lr_MigraArckmm.Mes             := TO_NUMBER(TO_CHAR(Lr_MigraArckmm.Fecha,'MM'));
        Lr_MigraArckmm.no_fisico       := Lr_DetallePago.Numero_Referencia ;
        Lr_MigraArckmm.origen          := Lr_DetallePago.Prefijo;
        Lr_MigraArckmm.usuario_creacion:= Lr_DetallePago.Usr_Creacion;
        Lr_MigraArckmm.fecha_doc       := TRUNC(Lr_DetallePago.Fe_Creacion);
        Lr_MigraArckmm.Cod_Diario      := Lr_CabPlantillaCon.Cod_Diario;
        Lr_MigraArckmm.Id_Forma_Pago   := Lr_DetallePago.ID_FORMA_PAGO;
        Lr_MigraArckmm.Id_Oficina_Facturacion := Lr_DetallePago.Oficina_Id;
        Lr_MigraArckmm.Comentario      := F_GENERA_COMENTARIO(Lr_DetallePago, '', Lr_CabPlantillaCon.FORMATO_GLOSA);
        Lr_MigraArckmm.Monto           := NVL(Lr_DetallePago.MONTO,0);
        Lr_MigraArckmm.Estado          := 'P';
        Lr_MigraArckmm.Conciliado      := 'N';
        Lr_MigraArckmm.Procedencia     := 'C';
        Lr_MigraArckmm.Ind_otromov     := 'S';
        Lr_MigraArckmm.Moneda_cta      := 'P';
        Lr_MigraArckmm.Tipo_cambio     := '1';
        Lr_MigraArckmm.T_camb_c_v      := 'C';
        Lr_MigraArckmm.Ind_otros_meses := 'N';
        Lr_MigraArckmm.Ind_Division    := 'N';
        Lr_MigraArckmm.No_Docu         := Lr_DetallePago.Id_Pago_Det;
        --
        if nvl(Lv_BanderaReplicar,'N') = 'S' AND Pv_NoCia = Lv_EmpresaOrigen then
          Lr_MigraArckmm.Id_Migracion := NAF47_TNET.TRANSA_ID.MIGRA_CK (Lv_EmpresaOrigen);
          Ln_IdMigracion33 := Lr_MigraArckmm.Id_Migracion;
          Ln_IdMigracion18 := NAF47_TNET.TRANSA_ID.MIGRA_CK (Lv_EmpresaDestino);
        else
          Lr_MigraArckmm.Id_Migracion := NAF47_TNET.TRANSA_ID.MIGRA_CK (Pv_NoCia);
        end if; 
        --
        NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKMM(Lr_MigraArckmm, Pv_MensajeError);
        IF Pv_MensajeError IS NOT NULL THEN
          Pv_MensajeError := 'PagoDet: '||Lr_DetallePago.Id_Pago_Det||'. '||Pv_MensajeError;
          RAISE Le_Error;
        END IF;
        --
        if nvl(Lv_BanderaReplicar,'N') = 'S' AND Pv_NoCia = Lv_EmpresaOrigen then
          declare
            Ln_IdOficinaMap number;
          begin
            select id_oficina INTO Ln_IdOficinaMap
                      from DB_COMERCIAL.INFO_OFICINA_GRUPO b
                     where b.NOMBRE_OFICINA = (select replace(A.NOMBRE_OFICINA, 'ECUANET', 'MEGADATOS')
                                                 from DB_COMERCIAL.INFO_OFICINA_GRUPO a
                                                where a.id_oficina = Lr_MigraArckmm.Id_Oficina_Facturacion);
                                                
            Lr_MigraArckmm.No_Cia := Lv_EmpresaDestino;
            Lr_MigraArckmm.Id_Oficina_Facturacion := Ln_IdOficinaMap;
            Lr_MigraArckmm.Id_Migracion := Ln_IdMigracion18;
            
            NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKMM(Lr_MigraArckmm, Pv_MensajeError);
            
            Lr_MigraArckmm.No_Cia := Pv_NoCia;
            Lr_MigraArckmm.Id_Migracion := Ln_IdMigracion33;
            Lr_MigraArckmm.Id_Oficina_Facturacion := Lr_DetallePago.Oficina_Id;
            
          end;
        end if;
        --

        -- generaci�n detalle de Contabilizaci�n.
        P_CREA_DEBITO_CREDITO( Lr_CabPlantillaCon,
                               Lr_DetallePago,
                               Lr_MigraArckmm,
                               Lr_MigraArcgae,
                               Pv_MensajeError,
                               Ln_IdMigracion18);
        --
        IF Pv_MensajeError != 'OK' THEN
          RAISE Le_Error;
        ELSE
          Pv_MensajeError := NULL;
          -- se acumulan los detalles de documentos que se estan contabilizando
          --Lr_MigraArckmm.Monto := NVL(Lr_MigraArckmm.Monto,0) + NVL(Lr_DetallePago.MONTO,0);
          --
        END IF;
        --
        Lr_MigraDocAsociado.DOCUMENTO_ORIGEN_ID := Lr_DetallePago.ID_PAGO_DET;
        Lr_MigraDocAsociado.MIGRACION_ID        := Lr_MigraArckmm.ID_MIGRACION;
        Lr_MigraDocAsociado.TIPO_DOC_MIGRACION  := Lr_CabPlantillaCon.COD_DIARIO;
        Lr_MigraDocAsociado.NO_CIA              := Pv_NoCia;
        Lr_MigraDocAsociado.FORMA_PAGO_ID       := Lr_CabPlantillaCon.ID_FORMA_PAGO;
        Lr_MigraDocAsociado.TIPO_DOCUMENTO_ID   := Lr_DetallePago.TIPO_DOCUMENTO_ID;
        Lr_MigraDocAsociado.ESTADO              := 'M';
        Lr_MigraDocAsociado.TIPO_MIGRACION      := 'CK';
        Lr_MigraDocAsociado.USR_CREACION        := Lr_DetallePago.USR_CREACION;
        Lr_MigraDocAsociado.FE_CREACION         := SYSDATE;
        --
        NAF47_TNET.GEK_MIGRACION.P_PROCESA_MIGRA_DOC_ASOCIADO( Lr_MigraDocAsociado,
                                                               'I',
                                                               Pv_MensajeError);
        --
        IF Pv_MensajeError IS NOT NULL THEN
          RAISE Le_Error;
        END IF;
        
        IF nvl(Lv_BanderaReplicar,'N') = 'S' AND Pv_NoCia = Lv_EmpresaOrigen then
          Lr_MigraDocAsociado.MIGRACION_ID := Ln_IdMigracion18;
          Lr_MigraDocAsociado.NO_CIA := Lv_EmpresaDestino;
          
          NAF47_TNET.GEK_MIGRACION.P_PROCESA_MIGRA_DOC_ASOCIADO( Lr_MigraDocAsociado,
                                                               'I',
                                                               Pv_MensajeError);
          
          IF Pv_MensajeError IS NOT NULL THEN
             RAISE Le_Error;
          END IF;
        
          Lr_MigraDocAsociado.MIGRACION_ID := Ln_IdMigracion33;
          Lr_MigraDocAsociado.NO_CIA := Lv_EmpresaOrigen;
        end if;
        --
        -- se marca el pago como contabilizado
        DB_FINANCIERO.FNKG_CONTABILIZAR_PAGO_MANUAL.MARCA_CONTABILIZADO_PAGO(Lr_DetallePago.ID_PAGO_DET,
                                                                             Lr_DetallePago.PAGO_ID,
                                                                             Lr_DetallePago.ESTADO_PAGO);
        --

      END LOOP;
      --
      -- se actualiza el total del documento generado
      --UPDATE MIGRA_ARCKMM
      --SET MONTO = Lr_MigraArckmm.Monto
      --WHERE ID_MIGRACION = Lr_MigraArckmm.Id_Migracion
      --AND NO_CIA = Lr_MigraArckmm.No_Cia;
      --
    END LOOP; -- fin detalle parametros
    --
    COMMIT;
    --
  EXCEPTION
    WHEN Le_Error THEN
      Pv_MensajeError := 'Error en FNKG_PAGO_LINEA_RECAUDACION.P_CONTABILIZAR. '||Pv_MensajeError;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                            'FNKG_PAGO_LINEA_RECAUDACION.P_CONTABILIZAR',
                                            Pv_MensajeError,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en FNKG_PAGO_LINEA_RECAUDACION.P_CONTABILIZAR. '||SQLERRM;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL .INSERT_ERROR( 'Telcos+',
                                            'FNKG_PAGO_LINEA_RECAUDACION.P_CONTABILIZAR',
                                            Pv_MensajeError,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

  END P_CONTABILIZAR;

  PROCEDURE P_CONTABILIZAR_ASIGNA_ANT_PTO ( Pv_NoCia        IN VARCHAR2,
                                            Pn_IdPagoCab    IN NUMBER,
                                            Pv_MensajeError IN OUT VARCHAR2) IS
    --
    CURSOR C_DOCUMENTO_CRUCE IS
      SELECT A.CODIGO_TIPO_DOCUMENTO
      FROM DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO A
      WHERE UPPER(A.NOMBRE_TIPO_DOCUMENTO) = 'ASIGNA PAGO SIN CLIENTE';
    --
    CURSOR C_CRUCE_ANTICIPO_SIN_CLIENTE IS
      --
      SELECT APD.ID_PARAMETRO_DET,
        APD.PARAMETRO_ID,
        APD.VALOR1 PARAMETRO_TIPO_DOC,
        APD.VALOR2 PREFIJO_TIPO_DOCUMENTO,
        APD.VALOR3 PREFIO_FORMA_PAGO,
        APD.VALOR4 TIPO_PROCESO,
        APD.VALOR5
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
        DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APC.ID_PARAMETRO    = APD.PARAMETRO_ID
      AND APC.ESTADO            = NVL(Gv_EstadoAtivo, APC.ESTADO )
      AND APD.ESTADO            = NVL(Gv_EstadoAtivo, APD.ESTADO )
      AND APC.NOMBRE_PARAMETRO  = NVL(Gv_NombreParametro, APC.NOMBRE_PARAMETRO )
      AND APD.DESCRIPCION       = NVL(Gv_NombreProceso, APD.DESCRIPCION )
      AND APD.VALOR1            = NVL(Gv_ParamTipoDocCruce, APD.VALOR1 )
      AND APD.EMPRESA_COD       = NVL(Pv_NoCia, APD.EMPRESA_COD );

    --
    CURSOR C_CRUCE_CLIENTES IS
      SELECT PD.ID_PAGO_DET,
        FP.DESCRIPCION_FORMA_PAGO,
        FP.CODIGO_FORMA_PAGO,
        PD.VALOR_PAGO,
        RD.FE_CREACION,
        P.NUMERO_PAGO,
        PD.NUMERO_CUENTA_BANCO,
        (SELECT LOGIN
         FROM DB_COMERCIAL.INFO_PUNTO PTO
         WHERE PTO.ID_PUNTO = P.PUNTO_ID ) LOGIN,
        P.USR_CREACION,
        OFI.NOMBRE_OFICINA,
        PD.CUENTA_CONTABLE_ID,
        PD.NUMERO_REFERENCIA,
        P.OFICINA_ID,
        EMP.PREFIJO,
        TDF.CODIGO_TIPO_DOCUMENTO,
        PD.PAGO_ID,
        PD.FORMA_PAGO_ID,
        P.TIPO_DOCUMENTO_ID,
        EMP.COD_EMPRESA,
        PD.FE_DEPOSITO,
        P.PUNTO_ID,
        P.ESTADO_PAGO,
        0,
        PD.BANCO_TIPO_CUENTA_ID
      FROM DB_FINANCIERO.INFO_PAGO_DET PD,
        DB_FINANCIERO.INFO_PAGO_CAB P,
        DB_FINANCIERO.INFO_RECAUDACION_DET RD,
        DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO TDF,
        DB_COMERCIAL.ADMI_FORMA_PAGO FP,
        DB_COMERCIAL.INFO_OFICINA_GRUPO OFI,
        DB_COMERCIAL.INFO_EMPRESA_GRUPO EMP
      WHERE PD.PAGO_ID = P.ID_PAGO
      AND P.RECAUDACION_DET_ID = RD.ID_RECAUDACION_DET
      AND P.TIPO_DOCUMENTO_ID = TDF.ID_TIPO_DOCUMENTO
      AND PD.FORMA_PAGO_ID = FP.ID_FORMA_PAGO
      AND P.OFICINA_ID = OFI.ID_OFICINA
      AND OFI.EMPRESA_ID = EMP.COD_EMPRESA
      AND P.EMPRESA_ID = Pv_NoCia
      AND PD.PAGO_ID = Pn_IdPagoCab
      --AND P.PUNTO_ID IS NOT NULL
      AND NOT EXISTS (SELECT NULL
                      FROM NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO MDA
                      WHERE MDA.DOCUMENTO_ORIGEN_ID = PD.ID_PAGO_DET
                      AND MDA.TIPO_MIGRACION = 'CG'
                      AND MDA.ESTADO = 'M')
      AND EXISTS (SELECT NULL -- valida estados de documento
                  FROM DB_GENERAL.ADMI_PARAMETRO_DET APD,
                    DB_GENERAL.ADMI_PARAMETRO_CAB APC
                  WHERE APD.VALOR2 = P.ESTADO_PAGO
                  AND APD.PARAMETRO_ID = APC.ID_PARAMETRO
                  AND APC.NOMBRE_PARAMETRO = Gv_NombreParametro
                  AND APC.ESTADO           = Gv_EstadoAtivo
                  AND APD.ESTADO           = Gv_EstadoAtivo
                  AND APD.DESCRIPCION      = Gv_NombreProceso
                  AND APD.VALOR1           = Gv_ParamEstCruceAntSinCli)
      AND EXISTS (SELECT NULL-- valida que solo recupere los ANTS
                  FROM DB_GENERAL.ADMI_PARAMETRO_DET APD,
                    DB_GENERAL.ADMI_PARAMETRO_CAB APC
                  WHERE APD.VALOR2 = TDF.CODIGO_TIPO_DOCUMENTO
                  AND APD.PARAMETRO_ID = APC.ID_PARAMETRO
                  AND APC.NOMBRE_PARAMETRO = Gv_NombreParametro
                  AND APC.ESTADO           = Gv_EstadoAtivo
                  AND APD.ESTADO           = Gv_EstadoAtivo
                  AND APD.DESCRIPCION      = Gv_NombreProceso
                  AND APD.VALOR1           = Gv_ParamTipoDocCruce);
    --
    Le_Error EXCEPTION;
    --
    Lr_CabPlantillaCon DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableCab;
    --
    Lv_CodDocCruce      DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE := NULL;
    Lr_MigraArckmm      NAF47_TNET.MIGRA_ARCKMM%ROWTYPE := NULL;
    Lr_MigraArcgae      NAF47_TNET.MIGRA_ARCGAE%ROWTYPE := NULL;
    Lr_MigraDocAsociado NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO%ROWTYPE := NULL;
    Lr_CruceCliente     TypeDetalleRecaudacion;
    --
    Ln_IdMigracion33 number;
    Ln_IdMigracion18 number;
    
    Lv_EmpresaOrigen db_general.admi_parametro_det.valor2%type;
    Lv_EmpresaDestino db_general.admi_parametro_det.valor2%type;
    Lv_BanderaReplicar db_general.admi_parametro_det.valor2%type;
  BEGIN
    --
    --Pv_MensajeError := 'Si Ingresa a Packages';
    --RAISE Le_Error;
    --
    Lv_EmpresaOrigen := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'EMPRESA_ORIGEN');
      Lv_EmpresaDestino := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'EMPRESA_DESTINO');
      Lv_BanderaReplicar := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'APLICA_REPLICA_MIGRACION');
    IF C_DOCUMENTO_CRUCE%ISOPEN THEN
      CLOSE C_DOCUMENTO_CRUCE;
    END IF;
    OPEN C_DOCUMENTO_CRUCE;
    FETCH C_DOCUMENTO_CRUCE INTO Lv_CodDocCruce;
    IF C_DOCUMENTO_CRUCE%NOTFOUND THEN
      Lv_CodDocCruce := NULL;
    END IF;
    CLOSE C_DOCUMENTO_CRUCE;
    --
    IF Lv_CodDocCruce IS NULL THEN
      Pv_MensajeError := 'No se ha configura tipo de documento Cruce de Anticipos sin Cliente';
      RAISE Le_Error;
    END IF;
    --
    FOR Lr_AnticipoSinCliente IN C_CRUCE_ANTICIPO_SIN_CLIENTE LOOP
      --
      IF Lr_AnticipoSinCliente.Prefijo_Tipo_Documento IS NULL THEN
        Pv_MensajeError := 'No se ha definido prefijo Tipo Documento (Valor2) en Parametro: '||Gv_NombreParametro||', proceso: '||Gv_NombreProceso;
        RAISE Le_Error;
      ELSIF Lr_AnticipoSinCliente.Prefio_Forma_Pago IS NULL THEN
        Pv_MensajeError := 'No se ha definido prefijo Forma de Pago (Valor3) en Parametro: '||Gv_NombreParametro||', proceso: '||Gv_NombreProceso;
        RAISE Le_Error;
      ELSIF Lr_AnticipoSinCliente.Tipo_Proceso IS NULL THEN
        Pv_MensajeError := 'No se ha definido Tipo de Proceso (Valor4) en Parametro: '||Gv_NombreParametro||', proceso: '||Gv_NombreProceso;
        RAISE Le_Error;
      END IF;
      -- se inicializa variable registro migra arcgae
      Lr_MigraArcgae := null;
      -- se recuperan datos de la cabecera de plantilla con la que se va a trabajr.
      Lr_CabPlantillaCon := DB_FINANCIERO.FNKG_CONTABILIZAR_PAGO_MANUAL .GET_PLANTILLA_CONTABLE_CAB_COD( Pv_NoCia,
                                                                                                        Lr_AnticipoSinCliente.Prefio_Forma_Pago,
                                                                                                        Lv_CodDocCruce ,
                                                                                                        Lr_AnticipoSinCliente.Tipo_Proceso);
      --
      IF Lr_CabPlantillaCon.ID_PLANTILLA_CONTABLE_CAB IS NULL THEN
        Pv_MensajeError := 'No se ha definido Plantilla contable para documento '||Lv_CodDocCruce||', forma pago: '||Lr_AnticipoSinCliente.Prefio_Forma_Pago||' y tipo proceso: '||Lr_AnticipoSinCliente.Tipo_Proceso;
        RAISE Le_Error;
      END IF;
      --
      -- detalle de anticipo sin cliente
      FOR Lr_CruceCliente IN C_CRUCE_CLIENTES  LOOP
        --
        IF Lr_CruceCliente.Login IS NULL THEN
          Pv_MensajeError := 'Pare el pago '||Pn_IdPagoCab||' no se encuentra asociado nig�n punto';
          RAISE Le_Error;
        END IF;

        Lr_MigraDocAsociado := NULL;
        --
        Lr_MigraArcgae .No_Cia := Lr_CruceCliente.Cod_Empresa;
        Lr_MigraArcgae.No_Asiento := P_GENERA_NO_DOCU_ASIENTO( Lr_CabPlantillaCon.FORMATO_NO_DOCU_ASIENTO,
                                                               Lr_CruceCliente.ID_PAGO_DET,
                                                               Lr_CruceCliente);
        Lr_MigraArcgae.Fecha := Lr_CruceCliente.Fe_Creacion;
        Lr_MigraArcgae.Ano := TO_NUMBER(TO_CHAR(Lr_MigraArcgae.Fecha, 'YYYY'));
        Lr_MigraArcgae.Mes := TO_NUMBER(TO_CHAR(Lr_MigraArcgae.Fecha, 'MM'));
        Lr_MigraArcgae.Descri1 := F_GENERA_COMENTARIO( Lr_CruceCliente, Lr_MigraArcgae.NO_ASIENTO, Lr_CabPlantillaCon.FORMATO_GLOSA);
        Lr_MigraArcgae.Estado := 'P';
        Lr_MigraArcgae.Impreso := 'N';
        Lr_MigraArcgae.Autorizado := 'N';
        Lr_MigraArcgae.Origen := Lr_CruceCliente.Prefijo;
        Lr_MigraArcgae.t_Debitos := Lr_CruceCliente.Valor_Pago;
        Lr_MigraArcgae.t_Creditos := Lr_CruceCliente.Valor_Pago;
        Lr_MigraArcgae.Cod_Diario := Lr_CabPlantillaCon.COD_DIARIO;
        Lr_MigraArcgae.t_Camb_c_v := 'C';
        Lr_MigraArcgae.Tipo_Cambio := '1';
        Lr_MigraArcgae.Tipo_Comprobante := 'T';
        Lr_MigraArcgae.Anulado := 'N';
        Lr_MigraArcgae.Usuario_Creacion := Lr_CruceCliente.Usr_Creacion;
        Lr_MigraArcgae.Transferido := 'N';
        Lr_MigraArcgae.Fecha_Creacion := SYSDATE;
        Lr_MigraArcgae.Id_Forma_Pago := Lr_CruceCliente.Forma_Pago_Id;
        Lr_MigraArcgae.Id_Oficina_Facturacion := Lr_CruceCliente.Oficina_Id;
        
        if nvl(Lv_BanderaReplicar,'N') = 'S' AND Pv_NoCia = Lv_EmpresaOrigen then
          Lr_MigraArcgae.Id_Migracion := NAF47_TNET.TRANSA_ID.MIGRA_CG( Lv_EmpresaOrigen );
          Ln_IdMigracion33 := Lr_MigraArcgae.Id_Migracion;
          Ln_IdMigracion18 := NAF47_TNET.TRANSA_ID.MIGRA_CG( Lv_EmpresaDestino );
        else
          Lr_MigraArcgae.Id_Migracion := NAF47_TNET.TRANSA_ID.MIGRA_CG( Lr_MigraArcgae.No_Cia );
        end if;
        --
        IF Lr_MigraArcgae.No_Asiento IS NOT NULL THEN
          --
          NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAE(Lr_MigraArcgae, Pv_MensajeError);
          --
          IF Pv_MensajeError IS NOT NULL THEN
            RAISE Le_Error;
          END IF;
          --
          if nvl(Lv_BanderaReplicar,'N') = 'S' AND Lr_CruceCliente.Cod_Empresa = Lv_EmpresaOrigen then
            declare
            Ln_IdOficinaMap number;
          begin
            select id_oficina INTO Ln_IdOficinaMap
                      from DB_COMERCIAL.INFO_OFICINA_GRUPO b
                     where b.NOMBRE_OFICINA = (select replace(A.NOMBRE_OFICINA, 'ECUANET', 'MEGADATOS')
                                                 from DB_COMERCIAL.INFO_OFICINA_GRUPO a
                                                where a.id_oficina = Lr_CruceCliente.Oficina_Id);
                                                
            Lr_MigraArcgae .No_Cia := Lv_EmpresaDestino;
            Lr_MigraArcgae.Id_Oficina_Facturacion := Ln_IdOficinaMap;
            Lr_MigraArcgae.Id_Migracion := Ln_IdMigracion18;
            
            NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAE(Lr_MigraArcgae, Pv_MensajeError);
            --
            IF Pv_MensajeError IS NOT NULL THEN
              RAISE Le_Error;
            END IF;
            
            Lr_MigraArcgae .No_Cia := Lr_CruceCliente.Cod_Empresa;
            Lr_MigraArcgae.Id_Oficina_Facturacion := Lr_CruceCliente.Oficina_Id;
            Lr_MigraArcgae.Id_Migracion := Ln_IdMigracion33;
            end;
          end if;
        END IF;

        -- generaci�n detalle de Contabilizaci�n.
        P_CREA_DEBITO_CREDITO( Lr_CabPlantillaCon,
                               Lr_CruceCliente,
                               Lr_MigraArckmm,
                               Lr_MigraArcgae,
                               Pv_MensajeError,Ln_IdMigracion18);
        --
        IF Pv_MensajeError IS NOT NULL THEN
          RAISE Le_Error;
        END IF;
        -- se acumulan los detalles de documentos que se estan contabilizando
        Lr_MigraArckmm .Monto := NVL(Lr_MigraArckmm.Monto,0) + NVL(Lr_CruceCliente.Valor_Pago,0);

        --
        Lr_MigraDocAsociado.DOCUMENTO_ORIGEN_ID := Lr_CruceCliente.ID_PAGO_DET;
        Lr_MigraDocAsociado.MIGRACION_ID        := Lr_MigraArcgae.ID_MIGRACION;
        Lr_MigraDocAsociado.TIPO_DOC_MIGRACION  := Lr_CabPlantillaCon.COD_DIARIO;
        Lr_MigraDocAsociado.NO_CIA              := Pv_NoCia;
        Lr_MigraDocAsociado.FORMA_PAGO_ID       := Lr_CabPlantillaCon.ID_FORMA_PAGO;
        Lr_MigraDocAsociado.TIPO_DOCUMENTO_ID   := Lr_CruceCliente.TIPO_DOCUMENTO_ID;
        Lr_MigraDocAsociado.ESTADO              := 'M';
        Lr_MigraDocAsociado.TIPO_MIGRACION      := 'CG';
        Lr_MigraDocAsociado.USR_CREACION        := Lr_CruceCliente.USR_CREACION;
        Lr_MigraDocAsociado.FE_CREACION         := SYSDATE;
        --
        NAF47_TNET.GEK_MIGRACION.P_PROCESA_MIGRA_DOC_ASOCIADO( Lr_MigraDocAsociado,
                                                               'I',
                                                               Pv_MensajeError);
        --
        IF Pv_MensajeError IS NOT NULL THEN
          RAISE Le_Error;
        END IF;
        --
        IF nvl(Lv_BanderaReplicar,'N') = 'S' AND Pv_NoCia = Lv_EmpresaOrigen then
          Lr_MigraDocAsociado.MIGRACION_ID := Ln_IdMigracion18;
          Lr_MigraDocAsociado.NO_CIA := Lv_EmpresaDestino;
          
          NAF47_TNET.GEK_MIGRACION.P_PROCESA_MIGRA_DOC_ASOCIADO( Lr_MigraDocAsociado,
                                                               'I',
                                                               Pv_MensajeError);
          
          IF Pv_MensajeError IS NOT NULL THEN
             RAISE Le_Error;
          END IF;
        
          Lr_MigraDocAsociado.MIGRACION_ID := Ln_IdMigracion33;
          Lr_MigraDocAsociado.NO_CIA := Lv_EmpresaOrigen;
        end if;
        
        -- se marca el pago como contabilizado
        DB_FINANCIERO.FNKG_CONTABILIZAR_PAGO_MANUAL.MARCA_CONTABILIZADO_PAGO(Lr_CruceCliente.ID_PAGO_DET,
                                                                             Lr_CruceCliente.PAGO_ID,
                                                                             Lr_CruceCliente.ESTADO_PAGO);
        --

      END LOOP; -- fin cursos anticipo sin cliente
      --
    END LOOP; -- fin seleccionar anticipos sin clientes ya asignados


  EXCEPTION
    WHEN Le_Error THEN
      Pv_MensajeError := 'Error en FNKG_PAGO_LINEA_RECAUDACION.P_CONTABILIZAR_ASIGNA_ANT_PTO. '||Pv_MensajeError;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                            'FNKG_PAGO_LINEA_RECAUDACION.P_CONTABILIZAR_ASIGNA_ANT_PTO',
                                            Pv_MensajeError,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en FNKG_PAGO_LINEA_RECAUDACION.P_CONTABILIZAR_ASIGNA_ANT_PTO. '||SQLERRM;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL .INSERT_ERROR( 'Telcos+',
                                            'FNKG_PAGO_LINEA_RECAUDACION.P_CONTABILIZAR_ASIGNA_ANT_PTO',
                                            Pv_MensajeError,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

  END P_CONTABILIZAR_ASIGNA_ANT_PTO;

END FNKG_PAGO_LINEA_RECAUDACION;
/
