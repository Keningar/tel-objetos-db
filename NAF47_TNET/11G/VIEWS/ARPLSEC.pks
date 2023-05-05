CREATE  FORCE VIEW "NAF47_TNET"."ARPLSEC" ("NO_CIA", "AREA", "DEPA", "DIVISION", "SECCION", "DESCRI", "ENCARGA", "SUCURSAL") AS 
  SELECT "NO_CIA",
           "AREA",
           "DEPA",
           "DIVISION",
           "SECCION",
           "DESCRI",
           "ENCARGA",
           "SUCURSAL"
      FROM NAF47_TNET.ARPLSEC@GPOETNET;