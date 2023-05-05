CREATE  FORCE VIEW "NAF47_TNET"."ARGEPARAM" ("NO_PARAMETRO", "MODULO", "NO_CIA", "NOMBRE", "NOMBRE_C", "VALOR_TX", "VALOR_NR", "VALOR_DT", "ESTADO") AS 
  SELECT "NO_PARAMETRO",
           "MODULO",
           "NO_CIA",
           "NOMBRE",
           "NOMBRE_C",
           "VALOR_TX",
           "VALOR_NR",
           "VALOR_DT",
           "ESTADO"
      FROM NAF47_TNET.ARGEPARAM@GPOETNET;