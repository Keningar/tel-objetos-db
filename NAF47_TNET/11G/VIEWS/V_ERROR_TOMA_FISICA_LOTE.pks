CREATE  FORCE VIEW "NAF47_TNET"."V_ERROR_TOMA_FISICA_LOTE" ("NO_CIA", "NO_TOMA", "BODEGA", "NO_ARTI", "DESCRIPCION", "TOM_FISIC", "TOTAL_LOTE") AS 
  SELECT "NO_CIA",
           "NO_TOMA",
           "BODEGA",
           "NO_ARTI",
           "DESCRIPCION",
           "TOM_FISIC",
           "TOTAL_LOTE"
      FROM NAF47_TNET.V_ERROR_TOMA_FISICA_LOTE@GPOETNET;