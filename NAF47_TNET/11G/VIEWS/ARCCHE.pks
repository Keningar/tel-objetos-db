CREATE  FORCE VIEW "NAF47_TNET"."ARCCHE" ("NO_CIA", "NO_DOCU", "TIPO_DOC", "COD_ESTADO", "FECHA", "USUARIO", "BANCO", "CONCEPTO") AS 
  SELECT "NO_CIA",
           "NO_DOCU",
           "TIPO_DOC",
           "COD_ESTADO",
           "FECHA",
           "USUARIO",
           "BANCO",
           "CONCEPTO"
      FROM NAF47_TNET.ARCCHE@GPOETNET;