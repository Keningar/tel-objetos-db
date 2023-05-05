CREATE  FORCE VIEW "NAF47_TNET"."ARRHFE" ("NO_CIA", "COD_FAC", "DESCRIP", "VALOR_A", "VALOR_B", "VALOR_C", "VALOR_D") AS 
  SELECT "NO_CIA",
           "COD_FAC",
           "DESCRIP",
           "VALOR_A",
           "VALOR_B",
           "VALOR_C",
           "VALOR_D"
      FROM NAF47_TNET.ARRHFE@GPOETNET;