CREATE  FORCE VIEW "NAF47_TNET"."ARPLHF" ("NO_CIA", "ANO", "MES", "COD_PLA", "NO_PLA", "NO_EMPLE", "FORMULA_ID", "CONCEPTO_ID", "TIPO_M", "VALOR") AS 
  SELECT "NO_CIA",
           "ANO",
           "MES",
           "COD_PLA",
           "NO_PLA",
           "NO_EMPLE",
           "FORMULA_ID",
           "CONCEPTO_ID",
           "TIPO_M",
           "VALOR"
      FROM NAF47_TNET.ARPLHF@GPOETNET;