CREATE  FORCE VIEW "NAF47_TNET"."ARPLMIH" ("NO_CIA", "COD_PLA", "NO_INGRE", "ANO", "MES", "NO_PLANI", "TIPO_ING", "DEP_SAL_HORA", "TASA_MULT", "APARTIR_DE", "GRUPO_ING", "APLICA_A", "FORMULA_ID", "IND_CALCULO") AS 
  SELECT "NO_CIA",
           "COD_PLA",
           "NO_INGRE",
           "ANO",
           "MES",
           "NO_PLANI",
           "TIPO_ING",
           "DEP_SAL_HORA",
           "TASA_MULT",
           "APARTIR_DE",
           "GRUPO_ING",
           "APLICA_A",
           "FORMULA_ID",
           "IND_CALCULO"
      FROM NAF47_TNET.ARPLMIH@GPOETNET;