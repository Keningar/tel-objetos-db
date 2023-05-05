CREATE  FORCE VIEW "NAF47_TNET"."ARPLAN" ("NO_CIA", "NO_EMPLE", "COD_ANTICIPO", "FECHA", "ORIGEN", "COD_PLA", "MONTO", "SALDO") AS 
  SELECT "NO_CIA",
           "NO_EMPLE",
           "COD_ANTICIPO",
           "FECHA",
           "ORIGEN",
           "COD_PLA",
           "MONTO",
           "SALDO"
      FROM NAF47_TNET.ARPLAN@GPOETNET;