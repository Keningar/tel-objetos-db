CREATE OR REPLACE PACKAGE DB_FINANCIERO.FNKG_DINARDAP AS 
    /*
    * Documentaci�n para TYPE 'Lr_InfoDinardap'.
    * Record que me permite almancernar la informacion devuelta por el query principal.
    */
    TYPE Lr_InfoDinardap
    IS 
    RECORD(
        CODIGO  VARCHAR(100),
        FECHA_DATOS     DATE,
        TIPO_IDENTIFICACION     INFO_PERSONA.TIPO_IDENTIFICACION%TYPE,
        IDENTIFICACION_CLIENTE  INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
        NOMBRE_CLIENTE          INFO_PERSONA.RAZON_SOCIAL%TYPE,
        TIPO_TRIBUTARIO         INFO_PERSONA.TIPO_TRIBUTARIO%TYPE,
        GENERO                  INFO_PERSONA.GENERO%TYPE,
        ESTADO_CIVIL            INFO_PERSONA.ESTADO_CIVIL%TYPE,
        ORIGEN_INGRESOS         INFO_PERSONA.ORIGEN_INGRESOS%TYPE,
        ID_DOCUMENTO            INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
        NUMERO_FACTURA_SRI      INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE,
        VALOR_TOTAL             INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE,
        FE_EMISION              INFO_DOCUMENTO_FINANCIERO_CAB.FE_EMISION%TYPE,
        FE_VENCIMIENTO          INFO_DOCUMENTO_FINANCIERO_CAB.FE_EMISION%TYPE,
        FE_CANCELACION          INFO_DOCUMENTO_FINANCIERO_CAB.FE_EMISION%TYPE,
        PLAZO_OPERACION         NUMBER,
        RESTA_DIAS              NUMBER,
        CODIGO_FORMA_PAGO       DB_GENERAL.ADMI_FORMA_PAGO.CODIGO_FORMA_PAGO%TYPE,
        CODIGO_PROVINCIA        DB_GENERAL.ADMI_PARROQUIA.CODIGO_INEC_PARROQUIA%TYPE,
        CODIGO_CANTON           DB_GENERAL.ADMI_PARROQUIA.CODIGO_INEC_PARROQUIA%TYPE,
        CODIGO_PARROQUIA        DB_GENERAL.ADMI_PARROQUIA.CODIGO_INEC_PARROQUIA%TYPE,
        SALDO                   NUMBER,
        SALDO_OPERACION         NUMBER
    );

    TYPE P_InfoDinardap IS REF CURSOR RETURN Lr_InfoDinardap;
  --
  --
  /*
  * Documentaci�n para PROCEDURE 'P_DINARDAP_POR_CLIENTE'.
  *
  * Procedure que me permite obtener todos los clientes que poseen las siguientes caracteristicas:
  *  --Por el tipo de forma de pago vamos discriminar cliente, no se deben listar CANJ, CORT
  *  --Se discrimina facturas segun el salario de la tabla admi_parametro_dinardap
  *  --Datos de migracion, se debe excluir
  *
  * PARAMETROS:
  * @Param varchar2 Pv_PrefijoEmpresa (empresa a generar el reporte)
  * @return P_InfoDinardap P_ClientesDinardap (cursor con la informacion de los clientes y factura)
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 28-10-2016 - Se actualiza la funci�n 'F_SALDO_X_FACTURA' a�adiendole NULL al par�metro 'fechaConsultaHasta' para que retorne todo
  *                           el saldo correspondiente a la factura.
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.2 15-09-2017 - Se actualiza la funci�n 'F_SALDO_X_FACTURA' a�adiendole 'saldo' al par�metro 'Fv_TipoConsulta' para que retorne todo
  *                           el saldo correspondiente a la factura.
  */
  PROCEDURE P_DINARDAP_POR_CLIENTE(
      Pv_PrefijoEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
      P_ClientesDinardap OUT P_InfoDinardap);
  --
  -- 
    /*
    * Documentaci�n para FUNCTION 'F_OBTENER_VALOR_FACTURA'.
    * Funcion que me permite el valor para las facturas de tope minimo
    *
    * PARAMETROS:
    * @Param varchar2 Fn_Anio (A�o del reporte)
    * @return Number Ln_ValorFacturas (Valor minimo de las facturas)
    */  
    FUNCTION F_OBTENER_VALOR_FACTURA(Fn_Anio IN VARCHAR2) RETURN NUMBER;
    
    /*
    * Documentaci�n para FUNCTION 'F_OBTENER_FECHA_MAXIMA_PAGO'.
    * Funcion que me permite obtener la fecha del ultimo pago realizado por el cliente
    *
    * PARAMETROS:
    * @Param number Fn_IdPunto (punto cliente)
    * @return Timestamp Lt_FeCreacion (fecha del maximo pago)
    */  
    FUNCTION F_OBTENER_FECHA_MAXIMA_PAGO(Fn_IdPunto IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                     Fn_IdDocumento IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE
)
  RETURN VARCHAR2;
    
    /**
    * Documentacion para el procedimiento P_SALDO_X_FACTURA_DINARDAP
    * El procedimiento P_SALDO_X_FACTURA_DINARDAP obtiene el saldo de la factura a consultar, 
    * en el cual NO se consideran los pagos con retencion
    *
    * @param  Pn_IdDocumento  Recibe el id de la factura
    * @param  Pn_ReferenciaId Recibe el id referencia del documento
    * @param  Pn_Saldo        Retorna el saldo
    * @param  Pv_MessageError Retorna un mensaje de error en caso de existir
    */
    PROCEDURE P_SALDO_X_FACTURA_DINARDAP(
    Pn_IdDocumento  IN  INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    Pn_ReferenciaId IN  INFO_DOCUMENTO_FINANCIERO_CAB.REFERENCIA_DOCUMENTO_ID%TYPE,
    Pn_Saldo        OUT NUMBER,
    Pv_MessageError OUT VARCHAR2);
    
    /*
    * Documentaci�n para FUNCION 'F_SALDO_X_FACTURA_DINARDAP'.
    * Funcion que permite obtener el saldo del documento.
    *
    * PARAMETROS:
    * @Param int id_documento (numero de tarjeta o cuenta que se desea desencriptar)
    * @return number saldo (saldo del documento)
    */
    FUNCTION F_SALDO_X_FACTURA_DINARDAP(id_documento IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE) RETURN NUMBER;
    
END FNKG_DINARDAP;
/

CREATE OR REPLACE PACKAGE BODY DB_FINANCIERO.DOCUMENTOS_ERROR AS 

  FUNCTION LOGIN_PARA_PAGO(punto IN NUMBER) RETURN VARCHAR2
  IS
   clogin VARCHAR2(1000);

   cursor cu1ogin is
   SELECT login
     FROM DB_COMERCIAL.INFO_PUNTO ip
     WHERE ip.id_punto=punto;
  BEGIN
      open cu1ogin;
      fetch cu1ogin into clogin;
      close cu1ogin;

    RETURN clogin;
  END;

  PROCEDURE PAGOS_FACTURA_ANULADA(id_punto IN NUMBER, listado OUT DocumentoErrorCur) 
  AS 
    BEGIN
    OPEN listado FOR 
      SELECT 
        'Pago [#'||ipc.NUMERO_PAGO||'] - [$'||ipd.VALOR_PAGO||'] asociado a Factura [#'||idfc.NUMERO_FACTURA_SRI||'] - [$'|| idfc.VALOR_TOTAL||'] en estado '|| idfc.ESTADO_IMPRESION_FACT as comentario_error,
        CASE 
        WHEN idfc.NUM_FACT_MIGRACION IS NOT NULL THEN 'Migrado'
        ELSE 'Telcos'
        END AS origen_documento,
        LOGIN_PARA_PAGO(ipc.PUNTO_ID) as login
      FROM 
        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB idfc,
        DB_FINANCIERO.INFO_PAGO_DET ipd,
        DB_FINANCIERO.INFO_PAGO_CAB ipc
      WHERE idfc.ESTADO_IMPRESION_FACT NOT IN ('Activo','Cerrado','Courier')
        AND ipd.REFERENCIA_ID=idfc.id_documento
        AND ipc.ID_PAGO=ipd.PAGO_ID
        AND ipc.ESTADO_PAGO NOT IN ('Anulado')
        AND idfc.PUNTO_ID=id_punto;
  END PAGOS_FACTURA_ANULADA;
  --
  PROCEDURE P_PAGOS_DEPENDIENTES(
  Pn_IdPunto           IN NUMBER,
  Pn_EmpresaId         IN VARCHAR2,
  Pr_ListadoPagosDep   OUT DocumentoErrorCur
  )
  IS
  --
  Lv_NombreMotivo               DB_GENERAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE     := 'ANULACION_DEPENCIA';
  Lv_EstadoMotivo               DB_GENERAL.ADMI_MOTIVO.ESTADO%TYPE            := 'Activo';
  Lv_EstadoPago                 DB_FINANCIERO.INFO_PAGO_CAB.ESTADO_PAGO%TYPE  := 'Anulado';

  BEGIN
  --
    OPEN Pr_ListadoPagosDep FOR 
          SELECT TRIM('Numero Pago: '|| IPC.NUMERO_PAGO|| ' | '|| IPH.OBSERVACION) AS COMENTARIO_ERROR ,
                 'Telcos' AS ORIGEN_DOCUMENTO,
                 DOCUMENTOS_ERROR.LOGIN_PARA_PAGO(IPC.PUNTO_ID) AS LOGIN
          FROM DB_FINANCIERO.INFO_PAGO_CAB IPC,
               DB_FINANCIERO.INFO_PAGO_HISTORIAL IPH
          WHERE IPC.ID_PAGO           =  IPH.PAGO_ID
          AND   IPC.PUNTO_ID          =  Pn_IdPunto
          AND   IPC.ESTADO_PAGO       <> Lv_EstadoPago  
          AND   IPC.EMPRESA_ID        =  Pn_EmpresaId  
          AND   IPH.MOTIVO_ID         =  (SELECT AM.ID_MOTIVO
                                         FROM  DB_GENERAL.ADMI_MOTIVO AM
                                         WHERE AM.NOMBRE_MOTIVO = Lv_NombreMotivo
                                         AND   AM.ESTADO        = Lv_EstadoMotivo);
      --
  END P_PAGOS_DEPENDIENTES;

  PROCEDURE P_PAGOS_ERROR_ESTADO_CTA(
  Pn_IdPunto           IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
  Pn_EmpresaId         IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
  Pr_ListadoPagosDep   OUT DocumentoErrorCur
  )
  IS
  --
  Lv_NombreMotivo               DB_GENERAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE     := 'ANULACION_DEPENCIA';
  Lv_EstadoMotivo               DB_GENERAL.ADMI_MOTIVO.ESTADO%TYPE            := 'Activo';
  Lv_EstadoPago                 DB_FINANCIERO.INFO_PAGO_CAB.ESTADO_PAGO%TYPE  := 'Anulado';

  BEGIN
  --
    OPEN Pr_ListadoPagosDep FOR
      SELECT 
        'Pago [#'||ipc.NUMERO_PAGO||'] - [$'||ipd.VALOR_PAGO||'] asociado a Factura [#'||idfc.NUMERO_FACTURA_SRI||'] - [$'|| idfc.VALOR_TOTAL||'] en estado '|| idfc.ESTADO_IMPRESION_FACT AS COMENTARIO_ERROR,
        CASE 
        WHEN IDFC.NUM_FACT_MIGRACION IS NOT NULL THEN 'Migrado'
        ELSE 'Telcos'
        END AS ORIGEN_DOCUMENTO,
        IPT.LOGIN AS LOGIN
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
      LEFT JOIN DB_FINANCIERO.INFO_PAGO_DET IPD ON IDFC.ID_DOCUMENTO = IPD.REFERENCIA_ID 
      LEFT JOIN DB_FINANCIERO.INFO_PAGO_CAB IPC ON IPC.ID_PAGO       = IPD.PAGO_ID
      LEFT JOIN DB_COMERCIAL.INFO_PUNTO     IPT ON IPT.ID_PUNTO      = IPC.PUNTO_ID
      WHERE IDFC.ESTADO_IMPRESION_FACT NOT IN ('Activo','Cerrado','Courier')
        AND IPC.ESTADO_PAGO <> Lv_EstadoPago
        AND IDFC.PUNTO_ID   =  Pn_IdPunto
      UNION ALL 
        SELECT TRIM('Numero Pago: '|| IPC.NUMERO_PAGO|| ' | '|| IPH.OBSERVACION) AS COMENTARIO_ERROR ,
               'Telcos' AS ORIGEN_DOCUMENTO,
              IPT.LOGIN AS LOGIN
        FROM  DB_FINANCIERO.INFO_PAGO_CAB       IPC
        LEFT JOIN  DB_COMERCIAL.INFO_PUNTO           IPT ON IPT.ID_PUNTO = IPC.PUNTO_ID
        LEFT JOIN  DB_FINANCIERO.INFO_PAGO_HISTORIAL IPH ON IPC.ID_PAGO  =  IPH.PAGO_ID
        WHERE IPC.PUNTO_ID          =  Pn_IdPunto
        AND   IPC.ESTADO_PAGO       <> Lv_EstadoPago  
        AND   IPC.EMPRESA_ID        =  Pn_EmpresaId  
        AND   IPH.MOTIVO_ID         =  (
                                         SELECT AM.ID_MOTIVO
                                         FROM  DB_GENERAL.ADMI_MOTIVO AM
                                         WHERE AM.NOMBRE_MOTIVO = Lv_NombreMotivo
                                         AND   AM.ESTADO        = Lv_EstadoMotivo
                                       );
      --
  END P_PAGOS_ERROR_ESTADO_CTA;
  --
END DOCUMENTOS_ERROR;
/

ALTER PACKAGE "DB_FINANCIERO"."DOCUMENTOS_ERROR" 
  COMPILE BODY 
    PLSQL_OPTIMIZE_LEVEL=  2
    PLSQL_CODE_TYPE=  INTERPRETED
    PLSQL_DEBUG=  FALSE    PLSCOPE_SETTINGS=  'IDENTIFIERS:ALL'  NLS_LENGTH_SEMANTICS= BYTE
 REUSE SETTINGS TIMESTAMP '2023-04-09 02:09:58'
/
CREATE OR REPLACE PACKAGE BODY DB_FINANCIERO.FNKG_DINARDAP AS


FUNCTION F_OBTENER_VALOR_FACTURA(Fn_Anio IN VARCHAR2)
  RETURN NUMBER
   IS
      Ln_ValorFacturas DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE;
   BEGIN
      SELECT (VALOR*PORCENTAJE)/100 INTO Ln_ValorFacturas
      FROM DB_FINANCIERO.ADMI_PARAMETRO_DINARDAP
      WHERE ANIO = Fn_Anio;
      return(Ln_ValorFacturas);
   EXCEPTION 
   WHEN NO_DATA_FOUND THEN
    return 0;
END F_OBTENER_VALOR_FACTURA;  

FUNCTION F_OBTENER_FECHA_MAXIMA_PAGO(Fn_IdPunto IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                     Fn_IdDocumento IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE
)
  RETURN VARCHAR2
   IS
      Lt_FeCreacion VARCHAR2(100);
   BEGIN
      SELECT TO_CHAR(MAX(to_char(IPD.fe_creacion,'dd/mm/yyyy')))
      INTO Lt_FeCreacion
      FROM DB_FINANCIERO.INFO_PAGO_CAB IPC
      JOIN DB_FINANCIERO.INFO_PAGO_DET IPD ON IPC.ID_PAGO=IPD.PAGO_ID
      WHERE IPC.ESTADO_PAGO='Cerrado' 
      AND IPC.PUNTO_ID=Fn_IdPunto
      AND IPD.REFERENCIA_ID=Fn_IdDocumento;
   IF Lt_FeCreacion IS NULL THEN     
    Lt_FeCreacion:='N/A';
   END IF;
   return(Lt_FeCreacion);
   EXCEPTION 
   WHEN OTHERS THEN
    return 'N/A';
END F_OBTENER_FECHA_MAXIMA_PAGO; 

PROCEDURE P_SALDO_X_FACTURA_DINARDAP(
    Pn_IdDocumento  IN  INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    Pn_ReferenciaId IN  INFO_DOCUMENTO_FINANCIERO_CAB.REFERENCIA_DOCUMENTO_ID%TYPE,
    Pn_Saldo        OUT NUMBER,
    Pv_MessageError OUT VARCHAR2)
IS
  --
  CURSOR C_GetFactByNC(Cn_IdDocumento
    INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  IS
    SELECT
      IDFC.*
    FROM
      INFO_DOCUMENTO_FINANCIERO_CAB NC
    LEFT JOIN INFO_DOCUMENTO_FINANCIERO_CAB IDFC
    ON
      NC.REFERENCIA_DOCUMENTO_ID = IDFC.ID_DOCUMENTO
    LEFT JOIN ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF ON ATDF.ID_TIPO_DOCUMENTO = IDFC.TIPO_DOCUMENTO_ID
    AND ATDF.CODIGO_TIPO_DOCUMENTO IN ('FAC', 'FACP')
    AND ATDF.ESTADO = 'Activo'
    WHERE
      IDFC.ESTADO_IMPRESION_FACT IN ('Activo', 'Cerrado')
    AND NC.ID_DOCUMENTO           = Cn_IdDocumento;
  --
  CURSOR C_GetFactura(Cn_IdDocumento
    INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  IS
    SELECT
      IDFC.*
    FROM
      INFO_DOCUMENTO_FINANCIERO_CAB IDFC
    WHERE
      IDFC.ESTADO_IMPRESION_FACT IN ('Activo', 'Cerrado')
    AND IDFC.ID_DOCUMENTO         = Cn_IdDocumento;
  --
  CURSOR C_GetNotaCredito(Cn_IdDocumento
    INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  IS
    SELECT
      SUM(NVL2(IDFC.VALOR_TOTAL, IDFC.VALOR_TOTAL, 0)) VALOR_TOTAL
    FROM
      INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
      ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
    WHERE
      IDFC.TIPO_DOCUMENTO_ID         = ATDF.ID_TIPO_DOCUMENTO
    AND ATDF.CODIGO_TIPO_DOCUMENTO  IN ('NC', 'NCI')
    AND ATDF.ESTADO                  = 'Activo'
    AND IDFC.ESTADO_IMPRESION_FACT  IN ('Activo')
    AND IDFC.REFERENCIA_DOCUMENTO_ID = Cn_IdDocumento;
  --
  CURSOR C_GetPagos(Cn_IdReferencia INFO_PAGO_DET.REFERENCIA_ID%TYPE)
  IS
    SELECT
      IPD.ID_PAGO_DET,
      IPD.VALOR_PAGO
    FROM
      INFO_PAGO_DET IPD,
      INFO_PAGO_CAB IPC,
      DB_GENERAL.ADMI_FORMA_PAGO AFP
    WHERE
      IPC.ID_PAGO         = IPD.PAGO_ID
    AND IPC.ESTADO_PAGO  IN ('Pendiente', 'Cerrado')
    AND IPD.REFERENCIA_ID = Cn_IdReferencia
    AND IPD.FORMA_PAGO_ID=AFP.ID_FORMA_PAGO
    AND AFP.CODIGO_FORMA_PAGO NOT IN ('RF2','RF8','RTF');
  --
  CURSOR C_GetNotaDebito(Cn_IdPagotDet INFO_PAGO_DET.ID_PAGO_DET%TYPE)
  IS
    SELECT
      SUM(NVL2(IDFC.VALOR_TOTAL, IDFC.VALOR_TOTAL, 0)) VALOR_TOTAL
    FROM
      INFO_DOCUMENTO_FINANCIERO_DET IDFD,
      INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
      ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
    WHERE
      IDFD.DOCUMENTO_ID             = IDFC.ID_DOCUMENTO
    AND IDFC.ESTADO_IMPRESION_FACT  IN ('Activo', 'Cerrado')
    AND IDFC.TIPO_DOCUMENTO_ID      = ATDF.ID_TIPO_DOCUMENTO
    AND ATDF.ESTADO                 = 'Activo'
    AND ATDF.CODIGO_TIPO_DOCUMENTO IN ('ND', 'NDI', 'DEV')
    AND IDFD.PAGO_DET_ID            = Cn_IdPagotDet;
  --
  Lc_GetFactura         INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE;
  Lc_GetNotaCredito     C_GetNotaCredito%ROWTYPE;
  Lc_GetPagos           C_GetPagos%ROWTYPE;
  Lc_GetNotaDebito      C_GetNotaDebito%ROWTYPE;
  Lr_GetAdmiFormaPago   FNKG_TYPES.Lr_AdmiFormaPago;
  Lrf_GetAdmiFormaPago  FNKG_TYPES.Lrf_AdmiFormaPago;
  Ln_TotalPago          NUMBER := 0;
  Ln_TotalND            NUMBER := 0;
  --
BEGIN
  --
  Lc_GetFactura := NULL;
  --Si el Pn_IdDocumento no es nulo obtiene la factura por la nota de credito con el campo referencia_documento_id
  IF Pn_IdDocumento IS NULL THEN
    --
    IF C_GetFactByNC%ISOPEN THEN
      --
      CLOSE C_GetFactByNC;
      --
    END IF;
    --
    OPEN C_GetFactByNC(Pn_ReferenciaId);
    --
    FETCH
      C_GetFactByNC
    INTO
      Lc_GetFactura;
    --
    CLOSE C_GetFactByNC;
    --
  ELSE
    --Obtiene la factura por su id documento
    IF C_GetFactura%ISOPEN THEN
      --
      CLOSE C_GetFactura;
      --
    END IF;
    --
    OPEN C_GetFactura(Pn_IdDocumento);
    --
    FETCH
      C_GetFactura
    INTO
      Lc_GetFactura;
    --
    CLOSE C_GetFactura;
    --
  END IF;--IF Pn_IdDocumento
  --
  Lc_GetNotaCredito := NULL;
  --Obtiene el total de las nota de credito
  IF C_GetNotaCredito%ISOPEN THEN
    --
    CLOSE C_GetNotaCredito;
    --
  END IF;
  --
  OPEN C_GetNotaCredito(Lc_GetFactura.ID_DOCUMENTO);
  --
  FETCH
    C_GetNotaCredito
  INTO
    Lc_GetNotaCredito;
  --
  CLOSE C_GetNotaCredito;
  --
  Ln_TotalPago := 0;
  Ln_TotalND   := 0;
  --Itera los pados de la factura para restar el valor total de la factura con el valor total de la nota de credito
  -- y restarlo al total de pagos y sumarle las notas de debito
  FOR I_GetPagos IN C_GetPagos(Lc_GetFactura.ID_DOCUMENTO)
  LOOP
    --
    Ln_TotalPago := Ln_TotalPago + NVL(I_GetPagos.VALOR_PAGO, 0);
    --
    IF C_GetNotaDebito%ISOPEN THEN
      --
      CLOSE C_GetNotaDebito;
      --
    END IF;
    --
    OPEN C_GetNotaDebito(I_GetPagos.ID_PAGO_DET);
    --
    FETCH
      C_GetNotaDebito
    INTO
      Lc_GetNotaDebito;
    --
    CLOSE C_GetNotaDebito;
    --
    Ln_TotalND := Ln_TotalND + NVL(Lc_GetNotaDebito.VALOR_TOTAL, 0);
    --
  END LOOP;--I_GetPagos
  --
  Pn_Saldo := NVL(Lc_GetFactura.VALOR_TOTAL, 0) - NVL(Lc_GetNotaCredito.VALOR_TOTAL, 0) - Ln_TotalPago + Ln_TotalND;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  Pv_MessageError := 'Error en FNKG_DINARDAP.P_SALDO_X_FACTURA_DINARDAP - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' 
                      || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
  FNCK_TRANSACTION.INSERT_ERROR('P_SALDO_X_FACTURA_DINARDAP', 
                                'FNKG_DINARDAP.P_SALDO_X_FACTURA_DINARDAP', 
                                'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  --
END P_SALDO_X_FACTURA_DINARDAP;


FUNCTION F_SALDO_X_FACTURA_DINARDAP(id_documento IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE) RETURN NUMBER 
IS 
  Pn_Saldo NUMBER;
    Pn_Error VARCHAR2(100);
BEGIN
  P_SALDO_X_FACTURA_DINARDAP(id_documento, null, Pn_Saldo, Pn_Error); 
  RETURN Pn_Saldo;
END;
  
PROCEDURE P_DINARDAP_POR_CLIENTE (Pv_PrefijoEmpresa  IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
                                  P_ClientesDinardap OUT P_InfoDinardap)
AS
    Pn_ValorFacturas DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE;
    Pc_Anio        VARCHAR2(10);
    Pc_MesAnterior VARCHAR2(100);
BEGIN

    --LLamada de la funcion para el valor de las facturas segun el parametro
    SELECT to_char(min(SYSDATE),'YYYY') as anio, TO_CHAR(TRUNC(sysdate, 'Month')-1,'DD-MON-YYYY') AS MES_ANTERIOR INTO Pc_Anio,Pc_MesAnterior 
            FROM DUAL;
    Pn_ValorFacturas:=F_OBTENER_VALOR_FACTURA(Pc_Anio);
    
    --Cursor con el listado de los clientes para la dinardap
    OPEN P_ClientesDinardap FOR 
      SELECT
      '' as codigo,
      to_char(sysdate,'dd/mm/yyyy') as fecha_datos,
      ip.tipo_identificacion,
      ip.identificacion_cliente,
      case
        when ip.razon_social is null then concat(concat(ip.apellidos,' '),ip.nombres)
        else ip.razon_social
      end as nombre_cliente,
      case
        when ip.tipo_tributario='NAT' then 'N'
        when ip.tipo_tributario='JUR' then 'J'
        else  ''
      end as tipo_tributario,
      ip.genero,
      ip.estado_civil,
      ip.origen_ingresos,
      idfc.id_documento,
      REPLACE(idfc.numero_factura_Sri,'-','') as numero_factura_Sri,
      round(idfc.valor_total,2) as valor_total,
      to_char(idfc.fe_emision,'dd/mm/yyyy') as fe_emision,
      case
        when tipo_documento_id=1 then to_char((trunc(idfc.fe_emision)+30),'dd/mm/yyyy')
        else to_char(add_months(idfc.fe_emision,1),'dd/mm/yyyy')
      end as fe_vencimiento,
      F_OBTENER_FECHA_MAXIMA_PAGO(ipu.id_punto,idfc.id_documento) as fe_cancelacion,
      (trunc(sysdate)-trunc(idfc.fe_emision)-1) as resta_dias,
      case
        when tipo_documento_id=1 then trunc(idfc.fe_emision)+30-trunc(idfc.fe_emision)
        else trunc(add_months(idfc.fe_emision,1))-trunc(fe_emision)
      end as plazo_operacion,
      case 
        when afp.CODIGO_FORMA_PAGO='CHEQ' then 'C'
        else 'E'
      end as CODIGO_FORMA_PAGO,
      SUBSTR(ap.codigo_inec_parroquia,1,2) as codigo_provincia,
      SUBSTR(ap.codigo_inec_parroquia,3,2) as codigo_canton,
      SUBSTR(ap.codigo_inec_parroquia,5,2) as codigo_parroquia,
      ROUND(FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA(idfc.ID_DOCUMENTO, NULL, 'saldo'),2) as saldo,
      ROUND(F_SALDO_X_FACTURA_DINARDAP(idfc.ID_DOCUMENTO),2) as saldo_operacion
      from info_persona ip
      join info_persona_empresa_rol iper on iper.persona_id=ip.id_persona
      join info_contrato ic on ic.PERSONA_EMPRESA_ROL_ID=iper.ID_PERSONA_ROL
      join DB_GENERAL.ADMI_FORMA_PAGO afp on afp.ID_FORMA_PAGO=ic.FORMA_PAGO_ID
      join info_punto ipu on ipu.PERSONA_EMPRESA_ROL_ID=iper.ID_PERSONA_ROL
      join INFO_DOCUMENTO_FINANCIERO_CAB idfc on idfc.PUNTO_ID=ipu.id_punto
      join INFO_EMPRESA_ROL ipr on ipr.ID_EMPRESA_ROL=iper.EMPRESA_ROL_ID
      join DB_GENERAL.ADMI_ROL ar on ar.id_rol=ipr.ROL_ID
      join INFO_EMPRESA_GRUPO ieg on ieg.cod_empresa=ipr.EMPRESA_COD
      join db_general.admi_sector ase on ase.id_sector=ipu.sector_id
      join db_general.admi_parroquia ap on ap.id_parroquia=ase.parroquia_id
      join db_general.admi_canton ac on ac.id_canton=ap.canton_id
      join DB_GENERAL.ADMI_PROVINCIA apr on apr.id_provincia=ac.provincia_id
      where
      ar.DESCRIPCION_ROL='Cliente'
      and idfc.estado_impresion_fact='Activo'
      and idfc.NUM_FACT_MIGRACION is null
      and idfc.TIPO_DOCUMENTO_ID in (1,5)
      and ieg.prefijo=Pv_PrefijoEmpresa
      and idfc.valor_total>Pn_ValorFacturas
      and afp.CODIGO_FORMA_PAGO not in ('CANJ','CORT')
      and trunc(idfc.fe_emision)<=Pc_MesAnterior
      and ipu.ID_PUNTO NOT IN (
        --Se reestringue puntos_id que poseen anticipos
        SELECT IPC.PUNTO_ID
        FROM DB_FINANCIERO.INFO_PAGO_CAB IPC
        JOIN ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF ON ATDF.ID_TIPO_DOCUMENTO=IPC.TIPO_DOCUMENTO_ID
        JOIN DB_COMERCIAL.INFO_PUNTO IP ON IP.ID_PUNTO=IPC.PUNTO_ID
        JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ON IPER.ID_PERSONA_ROL=IP.PERSONA_EMPRESA_ROL_ID
        JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO IOG ON IOG.ID_OFICINA=IPER.OFICINA_ID
        JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ON IEG.COD_EMPRESA=IOG.EMPRESA_ID
        where 
          IEG.PREFIJO=Pv_PrefijoEmpresa
          AND IPC.ESTADO_PAGO='Pendiente'
          AND ATDF.CODIGO_TIPO_DOCUMENTO IN ('ANT','ANTS','ANTC')
          AND ATDF.ESTADO='Activo'

      );
END P_DINARDAP_POR_CLIENTE;

END FNKG_DINARDAP;
/