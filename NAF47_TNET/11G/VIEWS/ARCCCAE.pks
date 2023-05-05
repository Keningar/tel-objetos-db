CREATE  FORCE VIEW "NAF47_TNET"."ARCCCAE" ("NO_CIA", "CENTRO", "NO_DOCU", "TIPO_DOC", "GRUPO", "NO_CLIENTE", "COD_ESTADO", "COD_ESTADO_NUE", "FECHA_DIGITACION", "FECHA", "USUARIO") AS 
  SELECT "NO_CIA",
           "CENTRO",
           "NO_DOCU",
           "TIPO_DOC",
           "GRUPO",
           "NO_CLIENTE",
           "COD_ESTADO",
           "COD_ESTADO_NUE",
           "FECHA_DIGITACION",
           "FECHA",
           "USUARIO"
      FROM NAF47_TNET.ARCCCAE@GPOETNET;