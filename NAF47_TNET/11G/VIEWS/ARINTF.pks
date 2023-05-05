CREATE  FORCE VIEW "NAF47_TNET"."ARINTF" ("NO_CIA", "NO_TOMA", "BODEGA", "NO_ARTI", "TOM_FISIC", "OBSERV1", "FIN_TOMA", "USUARIO_GENERA", "TSTAMP", "MARCA", "DIVISION", "SUBDIVISION", "DIFERENCIA", "DESCRIPCION") AS 
  SELECT "NO_CIA",
           "NO_TOMA",
           "BODEGA",
           "NO_ARTI",
           "TOM_FISIC",
           "OBSERV1",
           "FIN_TOMA",
           "USUARIO_GENERA",
           "TSTAMP",
           "MARCA",
           "DIVISION",
           "SUBDIVISION",
           "DIFERENCIA",
           "DESCRIPCION"
      FROM NAF47_TNET.ARINTF@GPOETNET;