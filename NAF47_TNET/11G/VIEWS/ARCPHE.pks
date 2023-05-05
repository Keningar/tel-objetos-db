
CREATE  FORCE VIEW "NAF47_TNET"."ARCPHE" ("NO_CIA", "NO_DOCU", "TIPO_DOC", "COD_ESTADO", "FECHA", "USUARIO", "NO_PROVE", "CONCEPTO") AS 
  SELECT "NO_CIA",
           "NO_DOCU",
           "TIPO_DOC",
           "COD_ESTADO",
           "FECHA",
           "USUARIO",
           "NO_PROVE",
           "CONCEPTO"
      FROM NAF47_TNET.ARCPHE@GPOETNET;