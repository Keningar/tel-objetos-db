CREATE  FORCE VIEW "NAF47_TNET"."TAFFCK" ("NO_CIA", "COD_CAJA", "ANO", "MES", "NO_CTA", "TIPO_DOC", "NO_SECUENCIA", "NO_DOCU", "FECHA", "IND_ANULADO", "MONTO", "MONTO_CK", "MONEDA", "DETALLE", "ORIGEN") AS 
  SELECT "NO_CIA",
           "COD_CAJA",
           "ANO",
           "MES",
           "NO_CTA",
           "TIPO_DOC",
           "NO_SECUENCIA",
           "NO_DOCU",
           "FECHA",
           "IND_ANULADO",
           "MONTO",
           "MONTO_CK",
           "MONEDA",
           "DETALLE",
           "ORIGEN"
      FROM NAF47_TNET.TAFFCK@GPOETNET;