CREATE  FORCE VIEW "NAF47_TNET"."ARCGRESUM2_CC" ("GRUPO", "NO_CIA", "CUENTA", "ANO", "MES", "CC_1", "CC_2", "CENTRO", "TOTAL", "SALDO_MENSUAL") AS 
  SELECT "GRUPO",
           "NO_CIA",
           "CUENTA",
           "ANO",
           "MES",
           "CC_1",
           "CC_2",
           "CENTRO",
           "TOTAL",
           "SALDO_MENSUAL"
      FROM NAF47_TNET.ARCGRESUM2_CC@GPOETNET;