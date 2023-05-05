CREATE  FORCE VIEW "NAF47_TNET"."ARPLGRC" ("NO_CIA", "NO_REP", "LINEA", "COL", "TITULO", "DESCRIP", "TOTALIZAR", "CLASE", "REF", "ACUMULADOR") AS 
  SELECT "NO_CIA",
           "NO_REP",
           "LINEA",
           "COL",
           "TITULO",
           "DESCRIP",
           "TOTALIZAR",
           "CLASE",
           "REF",
           "ACUMULADOR"
      FROM NAF47_TNET.ARPLGRC@GPOETNET;