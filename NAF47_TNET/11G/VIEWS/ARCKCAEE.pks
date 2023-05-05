CREATE  FORCE VIEW "NAF47_TNET"."ARCKCAEE" ("NO_CIA", "NO_CTA", "PROCE", "TIPO_DOC", "NO_DOCU", "ANO", "MES", "TIPO_AJUSTE") AS 
  SELECT "NO_CIA",
           "NO_CTA",
           "PROCE",
           "TIPO_DOC",
           "NO_DOCU",
           "ANO",
           "MES",
           "TIPO_AJUSTE"
      FROM NAF47_TNET.ARCKCAEE@GPOETNET;