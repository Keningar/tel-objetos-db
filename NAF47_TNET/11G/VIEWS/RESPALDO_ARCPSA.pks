CREATE  FORCE VIEW "NAF47_TNET"."RESPALDO_ARCPSA" ("NO_CIA", "NO_PROVE", "ANO", "MES", "MONEDA", "SALDO", "DEBITOS", "CREDITOS", "SALDO_ANT") AS 
  SELECT "NO_CIA",
           "NO_PROVE",
           "ANO",
           "MES",
           "MONEDA",
           "SALDO",
           "DEBITOS",
           "CREDITOS",
           "SALDO_ANT"
      FROM NAF47_TNET.RESPALDO_ARCPSA@GPOETNET;