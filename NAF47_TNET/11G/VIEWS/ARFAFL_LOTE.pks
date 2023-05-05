CREATE  FORCE VIEW "NAF47_TNET"."ARFAFL_LOTE" ("NO_CIA", "CENTROD", "NO_FACTU", "BODEGA", "NO_ARTI", "NO_LINEA", "NO_LOTE", "UNIDADES", "FECHA_VENCE", "UBICACION") AS 
  SELECT "NO_CIA",
           "CENTROD",
           "NO_FACTU",
           "BODEGA",
           "NO_ARTI",
           "NO_LINEA",
           "NO_LOTE",
           "UNIDADES",
           "FECHA_VENCE",
           "UBICACION"
      FROM NAF47_TNET.ARFAFL_LOTE@GPOETNET;