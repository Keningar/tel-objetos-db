
CREATE  FORCE VIEW "NAF47_TNET"."ARPLINT_D" ("NO_CIA", "COD_PLA", "NO_EMPLE", "NO_DEDU", "MONTO_BASE", "TASA", "SALDO") AS 
  SELECT "NO_CIA",
           "COD_PLA",
           "NO_EMPLE",
           "NO_DEDU",
           "MONTO_BASE",
           "TASA",
           "SALDO"
      FROM NAF47_TNET.ARPLINT_D@GPOETNET;