CREATE  FORCE VIEW "NAF47_TNET"."TMP_ARCKCNCI" ("NO_CIA", "NO_CTA", "PROCEDENCIA", "TIPO_DOC", "NO_DOCU", "FECHA", "MONTO", "MES", "ANO", "NO_FISICO", "SERIE_FISICO", "TIPO_CAMBIO") AS 
  SELECT "NO_CIA",
           "NO_CTA",
           "PROCEDENCIA",
           "TIPO_DOC",
           "NO_DOCU",
           "FECHA",
           "MONTO",
           "MES",
           "ANO",
           "NO_FISICO",
           "SERIE_FISICO",
           "TIPO_CAMBIO"
      FROM NAF47_TNET.TMP_ARCKCNCI@GPOETNET;