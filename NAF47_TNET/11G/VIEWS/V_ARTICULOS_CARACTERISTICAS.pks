CREATE OR REPLACE VIEW "NAF47_TNET"."V_ARTICULOS_CARACTERISTICAS" ("NO_CIA", "NO_ARTI", "DESC_ARTICULO", "BODEGA", "MODELO", "MARCA", "DESC_BODEGA", "STOCK", "ESTADO_ARTI_ACTIVO", "ID_CANTON", "GRUPO", "SUBGRUPO") AS 
  SELECT "NO_CIA",
           "NO_ARTI",
           "DESC_ARTICULO",
           "BODEGA",
           "MODELO",
           "MARCA",
           "DESC_BODEGA",
           "STOCK",
           "ESTADO_ARTI_ACTIVO",
           "ID_CANTON",
           "GRUPO",
           "SUBGRUPO"
      FROM NAF47_TNET.V_ARTICULOS_CARACTERISTICAS@GPOETNET;