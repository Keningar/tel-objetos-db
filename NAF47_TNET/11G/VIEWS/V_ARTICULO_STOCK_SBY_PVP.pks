CREATE  FORCE VIEW "NAF47_TNET"."V_ARTICULO_STOCK_SBY_PVP" ("NO_CIA", "NO_ARTI", "DESCRIPCION", "STOCK", "SBYSTOCK", "PRECIO") AS 
  SELECT "NO_CIA",
           "NO_ARTI",
           "DESCRIPCION",
           "STOCK",
           "SBYSTOCK",
           "PRECIO"
      FROM NAF47_TNET.V_ARTICULO_STOCK_SBY_PVP@GPOETNET;