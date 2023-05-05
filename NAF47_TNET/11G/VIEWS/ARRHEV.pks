CREATE  FORCE VIEW "NAF47_TNET"."ARRHEV" ("NO_CIA", "NO_EMPLE", "FECHA", "TEMA", "FUENTE", "OTRAS", "COMPLETADO", "SEGUIMIENTO", "ACCION", "TIPO", "RESULTADO") AS 
  SELECT "NO_CIA",
           "NO_EMPLE",
           "FECHA",
           "TEMA",
           "FUENTE",
           "OTRAS",
           "COMPLETADO",
           "SEGUIMIENTO",
           "ACCION",
           "TIPO",
           "RESULTADO"
      FROM NAF47_TNET.ARRHEV@GPOETNET;