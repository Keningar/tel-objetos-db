CREATE  OR REPLACE VIEW "NAF47_TNET"."V_PRODUCTOS_STOCK" ("NO_CIA", "CENTRO", "ARTICULO", "OBSERVACION", "COSTO_UNI", "STOCK") AS 
  SELECT "NO_CIA",
           "CENTRO",
           "ARTICULO",
           "OBSERVACION",
           "COSTO_UNI",
           "STOCK"
      FROM NAF47_TNET.V_PRODUCTOS_STOCK@GPOETNET;