CREATE  FORCE VIEW "NAF47_TNET"."ARINHTF" ("NO_CIA", "NO_TOMA", "BODEGA", "NO_ARTI", "FECHA", "EXIST_PREP", "TOM_FISIC") AS 
  SELECT "NO_CIA",
           "NO_TOMA",
           "BODEGA",
           "NO_ARTI",
           "FECHA",
           "EXIST_PREP",
           "TOM_FISIC"
      FROM NAF47_TNET.ARINHTF@GPOETNET;