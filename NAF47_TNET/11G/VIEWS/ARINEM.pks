CREATE  FORCE VIEW "NAF47_TNET"."ARINEM" ("NO_CIA", "CENTRO", "TIPO_DOC", "PERIODO", "NO_DOCU", "VENDEDOR", "FECHA", "CONDUCE") AS 
  SELECT "NO_CIA",
           "CENTRO",
           "TIPO_DOC",
           "PERIODO",
           "NO_DOCU",
           "VENDEDOR",
           "FECHA",
           "CONDUCE"
      FROM NAF47_TNET.ARINEM@GPOETNET;