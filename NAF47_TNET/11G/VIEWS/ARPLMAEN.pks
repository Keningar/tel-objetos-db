CREATE  FORCE VIEW "NAF47_TNET"."ARPLMAEN" ("NO_CIA", "NO_EMPLE", "HORARIO", "COD_PLA", "D_ENTRA", "H_ENTRA", "D_SALE", "H_SALE", "TRABAJADAS", "AUTORIZA_EXT") AS 
  SELECT "NO_CIA",
           "NO_EMPLE",
           "HORARIO",
           "COD_PLA",
           "D_ENTRA",
           "H_ENTRA",
           "D_SALE",
           "H_SALE",
           "TRABAJADAS",
           "AUTORIZA_EXT"
      FROM NAF47_TNET.ARPLMAEN@GPOETNET;