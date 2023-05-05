
CREATE  FORCE VIEW "NAF47_TNET"."ARRHST_EDU" ("NO_CIA", "NO_SOLIC", "TITULO", "INSTITUCION", "GRADO", "FECHA", "LUGAR", "GRADUADO", "FECHA_GRADO") AS 
  SELECT "NO_CIA",
           "NO_SOLIC",
           "TITULO",
           "INSTITUCION",
           "GRADO",
           "FECHA",
           "LUGAR",
           "GRADUADO",
           "FECHA_GRADO"
      FROM NAF47_TNET.ARRHST_EDU@GPOETNET;