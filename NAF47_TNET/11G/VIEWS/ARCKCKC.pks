CREATE  FORCE VIEW "NAF47_TNET"."ARCKCKC" ("NO_CIA", "NO_CTA", "TIPO_DOC", "NO_DOCU", "FECHA", "MONTO", "CADUCAR") AS 
  SELECT "NO_CIA",
           "NO_CTA",
           "TIPO_DOC",
           "NO_DOCU",
           "FECHA",
           "MONTO",
           "CADUCAR"
      FROM NAF47_TNET.ARCKCKC@GPOETNET;