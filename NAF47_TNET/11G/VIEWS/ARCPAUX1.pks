CREATE  FORCE VIEW "NAF47_TNET"."ARCPAUX1" ("NO_CIA", "TIPO_DOC", "NO_DOCU", "NO_PROVE", "SALDO", "FECHA", "FECHA_VENCE", "MONEDA") AS 
  SELECT "NO_CIA",
           "TIPO_DOC",
           "NO_DOCU",
           "NO_PROVE",
           "SALDO",
           "FECHA",
           "FECHA_VENCE",
           "MONEDA"
      FROM NAF47_TNET.ARCPAUX1@GPOETNET;