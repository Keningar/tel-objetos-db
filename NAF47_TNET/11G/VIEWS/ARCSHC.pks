CREATE  FORCE VIEW "NAF47_TNET"."ARCSHC" ("NO_CIA", "ANO", "MES", "CUENTA", "CEN_COS", "SALDO_INI", "MOV_DB", "MOV_CR", "SALDO_ACT", "MOVIM_MES", "MONEDA") AS 
  SELECT "NO_CIA",
           "ANO",
           "MES",
           "CUENTA",
           "CEN_COS",
           "SALDO_INI",
           "MOV_DB",
           "MOV_CR",
           "SALDO_ACT",
           "MOVIM_MES",
           "MONEDA"
      FROM NAF47_TNET.ARCSHC@GPOETNET;