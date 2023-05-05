
CREATE  FORCE VIEW "NAF47_TNET"."ARINOM" ("NO_CIA", "CENTRO", "PERIODO", "NO_DOCU", "NO_ARTI", "BODEGA", "NO_LOTE", "UNIDADES", "MONTO", "UBICACION", "FECHA_VENCE") AS 
  SELECT "NO_CIA",
           "CENTRO",
           "PERIODO",
           "NO_DOCU",
           "NO_ARTI",
           "BODEGA",
           "NO_LOTE",
           "UNIDADES",
           "MONTO",
           "UBICACION",
           "FECHA_VENCE"
      FROM NAF47_TNET.ARINOM@GPOETNET;