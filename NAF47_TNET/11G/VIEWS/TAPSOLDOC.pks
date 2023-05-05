CREATE  FORCE VIEW "NAF47_TNET"."TAPSOLDOC" ("NO_CIA", "NO_SOLIC", "NO_LINEA_S", "NO_DOCU", "NO_LINEA_D", "TIPO") AS 
  SELECT "NO_CIA",
           "NO_SOLIC",
           "NO_LINEA_S",
           "NO_DOCU",
           "NO_LINEA_D",
           "TIPO"
      FROM NAF47_TNET.TAPSOLDOC@GPOETNET;