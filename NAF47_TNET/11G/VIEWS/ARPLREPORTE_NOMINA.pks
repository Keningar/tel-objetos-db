CREATE  FORCE VIEW "NAF47_TNET"."ARPLREPORTE_NOMINA" ("NO_CIA", "CONSULTA", "COD_PLA", "ANO", "MES", "SECUENCIA", "DATO") AS 
  SELECT "NO_CIA",
           "CONSULTA",
           "COD_PLA",
           "ANO",
           "MES",
           "SECUENCIA",
           "DATO"
      FROM NAF47_TNET.ARPLREPORTE_NOMINA@GPOETNET;