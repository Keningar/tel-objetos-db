CREATE  FORCE VIEW "NAF47_TNET"."ARPLANT" ("NO_CIA", "ANO", "MES", "NO_EMPLE", "SALDO_ANT", "MONTO_MES", "MONTO_INT", "MONTO_PRE") AS 
  SELECT "NO_CIA",
           "ANO",
           "MES",
           "NO_EMPLE",
           "SALDO_ANT",
           "MONTO_MES",
           "MONTO_INT",
           "MONTO_PRE"
      FROM NAF47_TNET.ARPLANT@GPOETNET;