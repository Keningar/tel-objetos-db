CREATE  FORCE VIEW "NAF47_TNET"."RESP_CIA02BANCOBOL_012007" ("NO_CIA", "NO_CTA", "PROCEDENCIA", "TIPO_DOC", "NO_DOCU", "FECHA", "BENEFICIARIO", "COMENTARIO", "MONTO", "DESCUENTO_PP", "ESTADO", "CONCILIADO", "MES", "ANO", "FECHA_ANULADO", "IND_BORRADO", "IND_OTROMOV", "MONEDA_CTA", "TIPO_CAMBIO", "TIPO_AJUSTE", "IND_DIST", "T_CAMB_C_V", "IND_OTROS_MESES", "MES_CONCILIADO", "ANO_CONCILIADO", "NO_FISICO", "SERIE_FISICO", "IND_CON", "NUMERO_CTRL", "ORIGEN", "USUARIO_CREACION", "USUARIO_ANULA", "USUARIO_ACTUALIZA", "FECHA_ACTUALIZA", "FECHA_DOC") AS 
  SELECT "NO_CIA",
           "NO_CTA",
           "PROCEDENCIA",
           "TIPO_DOC",
           "NO_DOCU",
           "FECHA",
           "BENEFICIARIO",
           "COMENTARIO",
           "MONTO",
           "DESCUENTO_PP",
           "ESTADO",
           "CONCILIADO",
           "MES",
           "ANO",
           "FECHA_ANULADO",
           "IND_BORRADO",
           "IND_OTROMOV",
           "MONEDA_CTA",
           "TIPO_CAMBIO",
           "TIPO_AJUSTE",
           "IND_DIST",
           "T_CAMB_C_V",
           "IND_OTROS_MESES",
           "MES_CONCILIADO",
           "ANO_CONCILIADO",
           "NO_FISICO",
           "SERIE_FISICO",
           "IND_CON",
           "NUMERO_CTRL",
           "ORIGEN",
           "USUARIO_CREACION",
           "USUARIO_ANULA",
           "USUARIO_ACTUALIZA",
           "FECHA_ACTUALIZA",
           "FECHA_DOC"
      FROM NAF47_TNET.RESP_CIA02BANCOBOL_012007@GPOETNET;