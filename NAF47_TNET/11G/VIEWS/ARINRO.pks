CREATE  FORCE VIEW "NAF47_TNET"."ARINRO" ("NO_CIA", "CENTRO", "NO_DOCU", "LINEA", "NO_LOTE", "UNIDADES", "UBICACION", "FECHA_VENCE") AS 
  SELECT "NO_CIA",
           "CENTRO",
           "NO_DOCU",
           "LINEA",
           "NO_LOTE",
           "UNIDADES",
           "UBICACION",
           "FECHA_VENCE"
      FROM NAF47_TNET.ARINRO@GPOETNET;