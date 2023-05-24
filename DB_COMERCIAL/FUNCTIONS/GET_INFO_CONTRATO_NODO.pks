CREATE OR REPLACE FUNCTION DB_COMERCIAL.GET_INFO_CONTRATO_NODO(
    Pn_IdSolicitud  IN INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
    Pv_dato    IN varchar2)
  RETURN VARCHAR2
IS
  
  -- Cursor que obtiene la informacion de contrato relacionado a una solicitud de nuevo nodo
  CURSOR C_GetInfoContratoNodo( Cn_IdDetalleSolicitud INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE)
  IS
    SELECT 
      CONT.VALOR_CONTRATO ARRIENDO,
      CONT.VALOR_ANTICIPO,
      ROUND(months_between(CONT.FE_FIN_CONTRATO,CONT.FE_INI_CONTRATO)/12) DURACION,
      TRUNC(CONT.FE_INI_CONTRATO) INICIO,
      TRUNC(CONT.FE_FIN_CONTRATO) VENCE,
      (SELECT DESCRIPCION_FORMA_PAGO FROM ADMI_FORMA_PAGO WHERE ID_FORMA_PAGO = CONT.FORMA_PAGO_ID) DESCRIPCION_FORMA_PAGO,     
      (SELECT NVL(DESCRIPCION_BANCO,'N/A')
      FROM ADMI_BANCO
      WHERE ID_BANCO = BCO_TIPO.BANCO_ID
      ) BANCO,
      (SELECT NVL(DESCRIPCION_CUENTA,'N/A')
      FROM ADMI_TIPO_CUENTA
      WHERE ID_TIPO_CUENTA = BCO_TIPO.TIPO_CUENTA_ID
      ) TIPO_CUENTA,
      PAGO.NUMERO_CTA_TARJETA NUMERO_CUENTA
    FROM INFO_DETALLE_SOL_CARACT SOLC,
      ADMI_CARACTERISTICA CARACT,
      INFO_CONTRATO CONT,
      DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO PAGO,
      ADMI_FORMA_PAGO FORMA_PAGO,
      ADMI_BANCO_TIPO_CUENTA BCO_TIPO
    WHERE SOLC.DETALLE_SOLICITUD_ID       = Cn_IdDetalleSolicitud
    AND SOLC.CARACTERISTICA_ID            = CARACT.ID_CARACTERISTICA
    AND CARACT.DESCRIPCION_CARACTERISTICA = 'CONTRATO'
    AND SOLC.VALOR                        = CONT.ID_CONTRATO
    AND CONT.ESTADO                       = 'Activo'
    AND PAGO.CONTRATO_ID                  = CONT.ID_CONTRATO
    AND PAGO.TIPO_CUENTA_ID               = FORMA_PAGO.ID_FORMA_PAGO
    AND BCO_TIPO.ID_BANCO_TIPO_CUENTA     = PAGO.BANCO_TIPO_CUENTA_ID;
  --
Lv_valor       VARCHAR2(100) := NULL;
Lv_anticipo    VARCHAR2(100) := NULL;
Lv_duracion    VARCHAR2(100) := NULL;
Lv_inicio      VARCHAR2(100) := NULL;
Lv_fin         VARCHAR2(100) := NULL;
Lv_forma_pago  VARCHAR2(100) := NULL;
Lv_banco       VARCHAR2(100) := NULL;
Lv_tipo_cuenta VARCHAR2(100) := NULL;
Lv_numero      VARCHAR2(100) := NULL;
Lv_output      VARCHAR2(100)  := NULL;
  
BEGIN
  --
  IF C_GetInfoContratoNodo%ISOPEN THEN
    --
    CLOSE C_GetInfoContratoNodo;
    --
  END IF;
  --
  OPEN C_GetInfoContratoNodo(Pn_IdSolicitud);
  --
  FETCH C_GetInfoContratoNodo
  INTO 
    Lv_valor,
    Lv_anticipo,
    Lv_duracion,
    Lv_inicio,
    Lv_fin,
    Lv_forma_pago,
    Lv_banco,
    Lv_tipo_cuenta,
    Lv_numero;
  --    
  IF Pv_dato    = 'VALOR' THEN
    Lv_output  := Lv_valor;
  ELSIF Pv_dato = 'ANTICIPO' THEN
    Lv_output  := Lv_anticipo;
  ELSIF Pv_dato = 'DURACION' THEN
    Lv_output  := Lv_duracion;
  ELSIF Pv_dato = 'INICIO' THEN
    Lv_output  := Lv_inicio;
  ELSIF Pv_dato = 'FIN' THEN
    Lv_output  := Lv_fin;
  ELSIF Pv_dato = 'FORMA_PAGO' THEN
    Lv_output  := Lv_forma_pago;
  ELSIF Pv_dato = 'BANCO' THEN
    Lv_output  := Lv_banco;
  ELSIF Pv_dato = 'TIPO_CUENTA' THEN
    Lv_output  := Lv_tipo_cuenta;
  ELSIF Pv_dato = 'NUMERO_CUENTA' THEN
    Lv_output  := Lv_numero;
  END IF;

  CLOSE C_GetInfoContratoNodo;
  --
  RETURN Lv_output;
  --  
END GET_INFO_CONTRATO_NODO;
/