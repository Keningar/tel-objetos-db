CREATE  FORCE VIEW "NAF47_TNET"."ARGEDIS" ("PAIS", "PROVINCIA", "CANTON", "DISTRITO", "DESCRIPCION") AS 
  SELECT "PAIS",
           "PROVINCIA",
           "CANTON",
           "DISTRITO",
           "DESCRIPCION"
      FROM NAF47_TNET.ARGEDIS@GPOETNET;