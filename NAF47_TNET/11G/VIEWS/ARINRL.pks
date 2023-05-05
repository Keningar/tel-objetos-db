CREATE  FORCE VIEW "NAF47_TNET"."ARINRL" ("NO_CIA", "CENTRO", "NO_DOCU", "LINEA", "BODEGA", "NO_ARTI", "UNIDADES", "NO_ORDEN", "LINEA_ORDEN") AS 
  SELECT "NO_CIA",
           "CENTRO",
           "NO_DOCU",
           "LINEA",
           "BODEGA",
           "NO_ARTI",
           "UNIDADES",
           "NO_ORDEN",
           "LINEA_ORDEN"
      FROM NAF47_TNET.ARINRL@GPOETNET;