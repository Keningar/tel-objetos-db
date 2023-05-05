CREATE  FORCE VIEW "NAF47_TNET"."ARPLHPRE" ("NO_CIA", "NO_EMPLE", "NO_DEDU", "NO_OPERA", "DESCRIPCION", "MONEDA", "TOTAL", "FECHA", "CUOTA") AS 
  SELECT "NO_CIA",
           "NO_EMPLE",
           "NO_DEDU",
           "NO_OPERA",
           "DESCRIPCION",
           "MONEDA",
           "TOTAL",
           "FECHA",
           "CUOTA"
      FROM NAF47_TNET.ARPLHPRE@GPOETNET;