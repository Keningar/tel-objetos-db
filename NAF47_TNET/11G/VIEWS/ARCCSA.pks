CREATE  FORCE VIEW "NAF47_TNET"."ARCCSA" ("NO_CIA", "GRUPO", "NO_CLIENTE", "ANO", "MES", "MONEDA", "SALDO") AS 
  SELECT "NO_CIA",
           "GRUPO",
           "NO_CLIENTE",
           "ANO",
           "MES",
           "MONEDA",
           "SALDO"
      FROM NAF47_TNET.ARCCSA@GPOETNET;