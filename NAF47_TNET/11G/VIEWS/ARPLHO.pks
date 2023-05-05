
CREATE  FORCE VIEW "NAF47_TNET"."ARPLHO" ("NO_CIA", "COD_PLA", "NO_EMPLE", "ANO", "MES", "PERIODO", "SAL_BAS", "DIAS_LAB", "DIAS_NOLAB", "H_LAB", "H_NOLAB", "JORNADA") AS 
  SELECT "NO_CIA",
           "COD_PLA",
           "NO_EMPLE",
           "ANO",
           "MES",
           "PERIODO",
           "SAL_BAS",
           "DIAS_LAB",
           "DIAS_NOLAB",
           "H_LAB",
           "H_NOLAB",
           "JORNADA"
      FROM NAF47_TNET.ARPLHO@GPOETNET;