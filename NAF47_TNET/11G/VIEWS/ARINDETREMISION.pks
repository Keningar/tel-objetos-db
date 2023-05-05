CREATE  FORCE VIEW "NAF47_TNET"."ARINDETREMISION" ("NO_CIA", "NO_TRANSA", "ANIO", "MES", "NO_LINEA", "NO_ARTI", "CANTIDAD", "NO_DOCU") AS 
  SELECT "NO_CIA",
           "NO_TRANSA",
           "ANIO",
           "MES",
           "NO_LINEA",
           "NO_ARTI",
           "CANTIDAD",
           "NO_DOCU"
      FROM NAF47_TNET.ARINDETREMISION@GPOETNET;