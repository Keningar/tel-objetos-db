CREATE  FORCE VIEW "NAF47_TNET"."ARCGRESUM_CC" ("GRUPO", "NO_CIA", "CUENTA", "ANO", "MES", "CC_1", "CC_2", "CENTRO", "TOTAL") AS 
  SELECT "GRUPO",
           "NO_CIA",
           "CUENTA",
           "ANO",
           "MES",
           "CC_1",
           "CC_2",
           "CENTRO",
           "TOTAL"
      FROM NAF47_TNET.ARCGRESUM_CC@GPOETNET;