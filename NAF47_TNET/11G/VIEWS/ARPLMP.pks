
CREATE  FORCE VIEW "NAF47_TNET"."ARPLMP" ("NO_CIA", "PUESTO", "DESCRI", "MINIMO", "MAXIMO", "PROMEDIO", "JEFE", "CODIGO_IESS") AS 
  SELECT "NO_CIA",
           "PUESTO",
           "DESCRI",
           "MINIMO",
           "MAXIMO",
           "PROMEDIO",
           "JEFE",
           "CODIGO_IESS"
      FROM NAF47_TNET.ARPLMP@GPOETNET;