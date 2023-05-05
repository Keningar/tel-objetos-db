CREATE  FORCE VIEW "NAF47_TNET"."ARINTFLO" ("NO_CIA", "NO_TOMA", "BODEGA", "NO_ARTI", "NO_LOTE", "CLASE", "CATEGORIA", "TOM_FISIC") AS 
  SELECT "NO_CIA",
           "NO_TOMA",
           "BODEGA",
           "NO_ARTI",
           "NO_LOTE",
           "CLASE",
           "CATEGORIA",
           "TOM_FISIC"
      FROM NAF47_TNET.ARINTFLO@GPOETNET;