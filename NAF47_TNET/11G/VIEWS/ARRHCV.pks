CREATE  FORCE VIEW "NAF47_TNET"."ARRHCV" ("NO_CIA", "NO_SOLIC", "NO_EMPLE", "TITULO", "INSTITUCION", "GRADO", "FECHA", "LUGAR") AS 
  SELECT "NO_CIA",
           "NO_SOLIC",
           "NO_EMPLE",
           "TITULO",
           "INSTITUCION",
           "GRADO",
           "FECHA",
           "LUGAR"
      FROM NAF47_TNET.ARRHCV@GPOETNET;