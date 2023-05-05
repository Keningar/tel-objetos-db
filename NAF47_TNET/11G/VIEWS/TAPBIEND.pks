CREATE  FORCE VIEW "NAF47_TNET"."TAPBIEND" ("NO_CIA", "NO_SOLIC", "NO_LINEA", "CODIGO_NI", "NO_ARTI", "DESCRIPCION", "CANTIDAD", "MEDIDA") AS 
  SELECT "NO_CIA",
           "NO_SOLIC",
           "NO_LINEA",
           "CODIGO_NI",
           "NO_ARTI",
           "DESCRIPCION",
           "CANTIDAD",
           "MEDIDA"
      FROM NAF47_TNET.TAPBIEND@GPOETNET;
      