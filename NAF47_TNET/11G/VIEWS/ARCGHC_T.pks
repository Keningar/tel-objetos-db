

CREATE  FORCE VIEW "NAF47_TNET"."ARCGHC_T" ("NO_CIA", "ANO", "MES", "PERIODO", "CUENTA", "CODIGO_TERCERO", "MOVIMIENTO", "MOV_DB", "MOV_CR", "SALDO", "MOV_DB_DOL", "MOV_CR_DOL", "SALDO_DOL") AS 
  SELECT "NO_CIA",
           "ANO",
           "MES",
           "PERIODO",
           "CUENTA",
           "CODIGO_TERCERO",
           "MOVIMIENTO",
           "MOV_DB",
           "MOV_CR",
           "SALDO",
           "MOV_DB_DOL",
           "MOV_CR_DOL",
           "SALDO_DOL"
      FROM NAF47_TNET.ARCGHC_T@GPOETNET;