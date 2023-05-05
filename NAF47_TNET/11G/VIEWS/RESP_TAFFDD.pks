CREATE  FORCE VIEW "NAF47_TNET"."RESP_TAFFDD" ("NO_CIA", "TRANSA_ID", "NO_LINEA", "TIPO_DOC", "NO_DOCU", "NO_FISICO", "NO_SERIE", "FECHA_DOCU", "RAZON_SOCIAL", "CODIGO_TERCERO", "DETALLE", "MONEDA", "TIPO_CAMBIO", "EXCENTO", "GRABADO", "MONTO", "COD_GASTO", "CUENTA", "CENTRO_COSTO", "EXISTE_EN_CXP", "LIQUIDACION", "ID_TRIBUTARIO", "MONTO_BIENES", "MONTO_SERV", "NO_PROVE", "CONCEPTO", "TOT_IMP", "TOT_RET", "TOT_IMP_ESPECIAL", "TOT_RET_ESPECIAL", "ESTADO", "IND_REGISTRO_NUEVO", "TIPO_FACTURA", "NO_AUTORIZACION_COMP", "FECHA_VALIDEZ_COMP") AS 
  SELECT "NO_CIA",
           "TRANSA_ID",
           "NO_LINEA",
           "TIPO_DOC",
           "NO_DOCU",
           "NO_FISICO",
           "NO_SERIE",
           "FECHA_DOCU",
           "RAZON_SOCIAL",
           "CODIGO_TERCERO",
           "DETALLE",
           "MONEDA",
           "TIPO_CAMBIO",
           "EXCENTO",
           "GRABADO",
           "MONTO",
           "COD_GASTO",
           "CUENTA",
           "CENTRO_COSTO",
           "EXISTE_EN_CXP",
           "LIQUIDACION",
           "ID_TRIBUTARIO",
           "MONTO_BIENES",
           "MONTO_SERV",
           "NO_PROVE",
           "CONCEPTO",
           "TOT_IMP",
           "TOT_RET",
           "TOT_IMP_ESPECIAL",
           "TOT_RET_ESPECIAL",
           "ESTADO",
           "IND_REGISTRO_NUEVO",
           "TIPO_FACTURA",
           "NO_AUTORIZACION_COMP",
           "FECHA_VALIDEZ_COMP"
      FROM NAF47_TNET.RESP_TAFFDD@GPOETNET;