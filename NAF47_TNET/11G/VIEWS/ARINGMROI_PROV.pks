CREATE  FORCE VIEW "NAF47_TNET"."ARINGMROI_PROV" ("NO_CIA", "NO_PROVE", "VENTAS", "COSTO_VENTAS", "INVENTARIO_PROMEDIO", "GMROI", "CLASIFICACION") AS 
  SELECT "NO_CIA",
           "NO_PROVE",
           "VENTAS",
           "COSTO_VENTAS",
           "INVENTARIO_PROMEDIO",
           "GMROI",
           "CLASIFICACION"
      FROM NAF47_TNET.ARINGMROI_PROV@GPOETNET;