CREATE  FORCE VIEW "NAF47_TNET"."TAPORDEE" ("NO_CIA", "NO_ORDEN", "ESTADO", "NO_PROVE", "IND_NO_INV", "FECHA", "FECHA_VENCE", "DIAS_ENTREGA", "NO_FACTURA", "BODEGA", "FORMA_PAGO", "TERMINO_PAGO", "MONTO", "IMP_VENTAS", "DESCUENTO", "TOTAL", "LUGAR_EMBARQUE", "FECHA_EMBARQUE", "LUGAR_DESTINO", "OBSERV", "ADJUDICADOR", "TIPO_CAMBIO", "MONEDA", "DESCUENTOP1", "DESCUENTOP2", "TSTAMP", "USUARIO", "NOSOLIC_ORIGEN", "ID_TIPO_FRECUENCIA_PAGO", "NUMERO_FRECUENCIA", "OBSERVACION_MODIFICA", "ID_EMPLEADO_MODIFICA", "MANEJA_ANTICIPO", "VALOR_FACTURADO", "VALOR_PAGADO", "ID_TIPO_TRANSACCION", "USUARIO_APRUEBA", "FECHA_APRUEBA", "USUARIO_AUTORIZA", "FECHA_AUTORIZA", "OBSERVACION_APRUEBA", "OBSERVACION_AUTORIZA", "TIPO_DISTRIBUCION_COSTO", "ID_DOCUMENTO_DISTRIBUCION", "PEDIDO_DETALLE_ID", "ID_PEDIDO", "LOGIN") AS 
  SELECT "NO_CIA",
           "NO_ORDEN",
           "ESTADO",
           "NO_PROVE",
           "IND_NO_INV",
           "FECHA",
           "FECHA_VENCE",
           "DIAS_ENTREGA",
           "NO_FACTURA",
           "BODEGA",
           "FORMA_PAGO",
           "TERMINO_PAGO",
           "MONTO",
           "IMP_VENTAS",
           "DESCUENTO",
           "TOTAL",
           "LUGAR_EMBARQUE",
           "FECHA_EMBARQUE",
           "LUGAR_DESTINO",
           "OBSERV",
           "ADJUDICADOR",
           "TIPO_CAMBIO",
           "MONEDA",
           "DESCUENTOP1",
           "DESCUENTOP2",
           "TSTAMP",
           "USUARIO",
           "NOSOLIC_ORIGEN",
           "ID_TIPO_FRECUENCIA_PAGO",
           "NUMERO_FRECUENCIA",
           "OBSERVACION_MODIFICA",
           "ID_EMPLEADO_MODIFICA",
           "MANEJA_ANTICIPO",
           "VALOR_FACTURADO",
           "VALOR_PAGADO",
           "ID_TIPO_TRANSACCION",
           "USUARIO_APRUEBA",
           "FECHA_APRUEBA",
           "USUARIO_AUTORIZA",
           "FECHA_AUTORIZA",
           "OBSERVACION_APRUEBA",
           "OBSERVACION_AUTORIZA",
           "TIPO_DISTRIBUCION_COSTO",
           "ID_DOCUMENTO_DISTRIBUCION",
           "PEDIDO_DETALLE_ID",
           "ID_PEDIDO",
           "LOGIN"
      FROM NAF47_TNET.TAPORDEE@GPOETNET;