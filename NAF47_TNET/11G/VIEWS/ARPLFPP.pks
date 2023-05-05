CREATE  FORCE VIEW "NAF47_TNET"."ARPLFPP" ("NO_CIA", "COD_PLA", "NO_EMPLE", "FORMULA_ID", "CONCEPTO_ID", "TIPO_M", "VALOR") AS 
  SELECT "NO_CIA",
           "COD_PLA",
           "NO_EMPLE",
           "FORMULA_ID",
           "CONCEPTO_ID",
           "TIPO_M",
           "VALOR"
      FROM NAF47_TNET.ARPLFPP@GPOETNET;