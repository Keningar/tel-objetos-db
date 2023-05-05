CREATE  FORCE VIEW "NAF47_TNET"."ARCPMD_MASIVA" ("NO_CIA", "NO_PROVE", "TIPO_DOC", "NO_DOCU", "NO_FISICO", "SERIE_FISICO", "SUBTOTAL", "MONTO", "SALDO", "GRAVADO", "EXCENTOS", "DESCUENTO", "TOT_REFER", "FECHA_DOCUMENTO", "ESTADO", "TSTAMP", "USER_CREA", "NO_DOCU_REFE") AS 
  SELECT "NO_CIA",
           "NO_PROVE",
           "TIPO_DOC",
           "NO_DOCU",
           "NO_FISICO",
           "SERIE_FISICO",
           "SUBTOTAL",
           "MONTO",
           "SALDO",
           "GRAVADO",
           "EXCENTOS",
           "DESCUENTO",
           "TOT_REFER",
           "FECHA_DOCUMENTO",
           "ESTADO",
           "TSTAMP",
           "USER_CREA",
           "NO_DOCU_REFE"
      FROM NAF47_TNET.ARCPMD_MASIVA@GPOETNET;