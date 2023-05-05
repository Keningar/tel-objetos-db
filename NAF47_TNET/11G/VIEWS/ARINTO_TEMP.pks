CREATE  FORCE VIEW "NAF47_TNET"."ARINTO_TEMP" ("NO_CIA", "CENTRO", "PERIODO", "NO_DOCU", "NO_ARTI", "NO_LOTE", "UNIDADES", "MONTO", "UBICACION", "FECHA_VENCE") AS 
  SELECT "NO_CIA",
           "CENTRO",
           "PERIODO",
           "NO_DOCU",
           "NO_ARTI",
           "NO_LOTE",
           "UNIDADES",
           "MONTO",
           "UBICACION",
           "FECHA_VENCE"
      FROM NAF47_TNET.ARINTO_TEMP@GPOETNET;