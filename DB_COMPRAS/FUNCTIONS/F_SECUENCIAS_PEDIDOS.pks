create or replace FUNCTION            F_SECUENCIAS_PEDIDOS(Pv_Tabla IN VARCHAR2)
  RETURN INTEGER AS
  l_rv NUMBER;

  cursor C_LeeSec IS
    SELECT DB_COMPRAS.SEQ_INFO_PEDIDO.nextval FROM DUAL;

  cursor C_LeePedidoDet IS
    SELECT DB_COMPRAS.SEQ_INFO_PEDIDO_DETALLE.nextval FROM DUAL;

  CURSOR C_LeePedidoAprobacion IS
    SELECT DB_COMPRAS.SEQ_INFO_PEDIDO_APROBACION.nextval FROM DUAL;
  --
  CURSOR C_LeePedidoEstado IS
    SELECT DB_COMPRAS.SEQ_INFO_PEDIDO_ESTADO.nextval FROM DUAL;

  CURSOR C_LeePedidoSolicitud IS
    SELECT DB_COMPRAS.SEQ_INFO_SOLICITUD.nextval FROM DUAL;
  --
  CURSOR C_LeeReservaProd IS
    SELECT DB_COMPRAS.SEQ_INFO_RESERVA_PRODUCTOS.NEXTVAL FROM DUAL;

BEGIN
  IF Pv_Tabla = 'INFO_PEDIDO' THEN
    IF C_LeeSec%ISOPEN THEN
      CLOSE C_LeeSec;
    END IF;
    OPEN C_LeeSec;
    FETCH C_LeeSec
      INTO l_rv;
    CLOSE C_LeeSec;
  END IF;
  --
  IF Pv_Tabla = 'INFO_PEDIDO_DETALLE' THEN
    IF C_LeePedidoDet%ISOPEN THEN
      CLOSE C_LeePedidoDet;
    END IF;
    OPEN C_LeePedidoDet;
    FETCH C_LeePedidoDet
      INTO l_rv;
    CLOSE C_LeePedidoDet;
  END IF;
  --
  IF Pv_Tabla = 'INFO_PEDIDO_APROBACION' THEN
    IF C_LeePedidoAprobacion%ISOPEN THEN
      CLOSE C_LeePedidoAprobacion;
    END IF;
    OPEN C_LeePedidoAprobacion;
    FETCH C_LeePedidoAprobacion
      INTO l_rv;
    CLOSE C_LeePedidoAprobacion;
  END IF;
  --
  IF Pv_Tabla = 'INFO_PEDIDO_ESTADO' THEN
    IF C_LeePedidoEstado%ISOPEN THEN
      CLOSE C_LeePedidoEstado;
    END IF;
    OPEN C_LeePedidoEstado;
    FETCH C_LeePedidoEstado
      INTO l_rv;
    CLOSE C_LeePedidoEstado;
  END IF;
  --
  --
  IF Pv_Tabla = 'INFO_SOLICITUD' THEN
    IF C_LeePedidoSolicitud%ISOPEN THEN
      CLOSE C_LeePedidoSolicitud;
    END IF;
    OPEN C_LeePedidoSolicitud;
    FETCH C_LeePedidoSolicitud
      INTO l_rv;
    CLOSE C_LeePedidoSolicitud;
  END IF;
  --
  IF Pv_Tabla = 'INFO_RESERVA_PRODUCTOS' THEN
    IF C_LeeReservaProd%ISOPEN THEN
      CLOSE C_LeeReservaProd;
    END IF;
    OPEN C_LeeReservaProd;
    FETCH C_LeeReservaProd
      INTO l_rv;
    CLOSE C_LeeReservaProd;
  END IF;
  RETURN l_rv;
END F_SECUENCIAS_PEDIDOS;
