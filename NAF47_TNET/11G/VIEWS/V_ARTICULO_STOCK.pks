CREATE  FORCE VIEW "NAF47_TNET"."V_ARTICULO_STOCK" ("NO_ARTI", "DESCRIPCION", "BODEGA", "UNIDAD", "STOCK", "NO_CIA", "ARTICULO", "CLASE", "MARCA") AS 
  SELECT "NO_ARTI",
           "DESCRIPCION",
           "BODEGA",
           "UNIDAD",
           "STOCK",
           "NO_CIA",
           "ARTICULO",
           "CLASE",
           "MARCA"
      FROM NAF47_TNET.V_ARTICULO_STOCK@GPOETNET;