CREATE  FORCE VIEW "NAF47_TNET"."ARFAAU" ("NO_CIA", "CENTRO", "USUARIO", "SISTEMA", "IND_ACTIVO") AS 
  SELECT "NO_CIA",
           "CENTRO",
           "USUARIO",
           "SISTEMA",
           "IND_ACTIVO"
      FROM NAF47_TNET.ARFAAU@GPOETNET;