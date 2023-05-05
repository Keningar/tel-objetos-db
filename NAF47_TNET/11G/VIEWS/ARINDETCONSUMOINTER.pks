CREATE  FORCE VIEW "NAF47_TNET"."ARINDETCONSUMOINTER" ("NO_CIA", "NO_ARTI", "NO_DOCU", "UNI_REQUERIDAS", "UNI_APROBADAS", "UNI_DEVUELTAS", "UNI_ENTREGADAS", "COSTO_CI", "CENTRO") AS 
  SELECT "NO_CIA",
           "NO_ARTI",
           "NO_DOCU",
           "UNI_REQUERIDAS",
           "UNI_APROBADAS",
           "UNI_DEVUELTAS",
           "UNI_ENTREGADAS",
           "COSTO_CI",
           "CENTRO"
      FROM NAF47_TNET.ARINDETCONSUMOINTER@GPOETNET;