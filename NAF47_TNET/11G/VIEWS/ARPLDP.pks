CREATE  FORCE VIEW "NAF47_TNET"."ARPLDP" ("NO_CIA", "AREA", "DEPA", "DESCRI", "ENCARGA", "MOVIMIENTO", "SUCURSAL", "ES_NACIONAL") AS 
  SELECT "NO_CIA",
           "AREA",
           "DEPA",
           "DESCRI",
           "ENCARGA",
           "MOVIMIENTO",
           "SUCURSAL",
           "ES_NACIONAL"
      FROM NAF47_TNET.ARPLDP@GPOETNET;