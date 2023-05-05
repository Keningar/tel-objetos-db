CREATE  FORCE VIEW "NAF47_TNET"."ARRHPTC" ("NO_CIA", "TIPO_CURSO", "AREA", "DEPTO", "ANO", "HORAS", "PRESUPUESTO") AS 
  SELECT "NO_CIA",
           "TIPO_CURSO",
           "AREA",
           "DEPTO",
           "ANO",
           "HORAS",
           "PRESUPUESTO"
      FROM NAF47_TNET.ARRHPTC@GPOETNET;