CREATE  FORCE VIEW "NAF47_TNET"."ARPLCE" ("NO_CIA", "ANO", "MES", "NO_EMPLE", "TIPO_CAMBIO", "FECHA_INICIO", "FECHA_FIN", "CLASE_CAMBIO", "HORASXDIA", "CLASE_JORNADA", "BORRADO", "ORIGEN") AS 
  SELECT "NO_CIA",
           "ANO",
           "MES",
           "NO_EMPLE",
           "TIPO_CAMBIO",
           "FECHA_INICIO",
           "FECHA_FIN",
           "CLASE_CAMBIO",
           "HORASXDIA",
           "CLASE_JORNADA",
           "BORRADO",
           "ORIGEN"
      FROM NAF47_TNET.ARPLCE@GPOETNET;