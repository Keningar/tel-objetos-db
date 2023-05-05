
CREATE  FORCE VIEW "NAF47_TNET"."ARPLDIV" ("NO_CIA", "AREA", "DEPA", "DIVISION", "DESCRI", "ENCARGA", "MOVIMIENTO", "SUCURSAL") AS 
  SELECT "NO_CIA",
           "AREA",
           "DEPA",
           "DIVISION",
           "DESCRI",
           "ENCARGA",
           "MOVIMIENTO",
           "SUCURSAL"
      FROM NAF47_TNET.ARPLDIV@GPOETNET;