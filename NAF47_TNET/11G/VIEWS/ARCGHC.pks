CREATE  FORCE VIEW "NAF47_TNET"."ARCGHC" ("NO_CIA", "ANO", "MES", "PERIODO", "CUENTA", "MOVIMIENTO", "MOV_DB", "MOV_CR", "SALDO", "MOV_DB_DOL", "MOV_CR_DOL", "SALDO_DOL", "AJUSTE_PCGAS", "SALDO_CONV", "TASA_CONV") AS 
  SELECT "NO_CIA",
           "ANO",
           "MES",
           "PERIODO",
           "CUENTA",
           "MOVIMIENTO",
           "MOV_DB",
           "MOV_CR",
           "SALDO",
           "MOV_DB_DOL",
           "MOV_CR_DOL",
           "SALDO_DOL",
           "AJUSTE_PCGAS",
           "SALDO_CONV",
           "TASA_CONV"
      FROM NAF47_TNET.ARCGHC@GPOETNET;