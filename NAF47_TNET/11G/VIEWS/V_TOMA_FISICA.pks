CREATE  FORCE VIEW "NAF47_TNET"."V_TOMA_FISICA" ("NO_TOMA", "NO_CIA", "NO_ARTI", "BODEGA", "TOM_FISIC", "EXIST_PREP", "DIFERENCIA", "FIN_TOMA", "OBSERV1") AS 
  SELECT "NO_TOMA",
           "NO_CIA",
           "NO_ARTI",
           "BODEGA",
           "TOM_FISIC",
           "EXIST_PREP",
           "DIFERENCIA",
           "FIN_TOMA",
           "OBSERV1"
      FROM NAF47_TNET.V_TOMA_FISICA@GPOETNET;