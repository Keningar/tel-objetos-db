CREATE  FORCE VIEW "NAF47_TNET"."ARINHTFLO" ("NO_CIA", "NO_TOMA", "BODEGA", "NO_ARTI", "NO_LOTE", "FECHA", "EXIST_PREP", "TOM_FISIC") AS 
  SELECT "NO_CIA",
           "NO_TOMA",
           "BODEGA",
           "NO_ARTI",
           "NO_LOTE",
           "FECHA",
           "EXIST_PREP",
           "TOM_FISIC"
      FROM NAF47_TNET.ARINHTFLO@GPOETNET;