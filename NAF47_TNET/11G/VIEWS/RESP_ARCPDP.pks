CREATE  FORCE VIEW "NAF47_TNET"."RESP_ARCPDP" ("NO_CIA", "NO_PROVE", "TIPO_DOC", "NO_DOCU", "FECHA_VENC", "MONTO", "DESCUENTO_PP", "APLICA_PRONTO_PAGO", "SALDO", "MONEDA", "TIPO_CAMBIO", "BANCO", "CTA_BANCARIA", "TIPO_PAGO", "FECHA_DPP", "SERIE_FISICO", "NO_FISICO") AS 
  SELECT "NO_CIA",
           "NO_PROVE",
           "TIPO_DOC",
           "NO_DOCU",
           "FECHA_VENC",
           "MONTO",
           "DESCUENTO_PP",
           "APLICA_PRONTO_PAGO",
           "SALDO",
           "MONEDA",
           "TIPO_CAMBIO",
           "BANCO",
           "CTA_BANCARIA",
           "TIPO_PAGO",
           "FECHA_DPP",
           "SERIE_FISICO",
           "NO_FISICO"
      FROM NAF47_TNET.RESP_ARCPDP@GPOETNET;