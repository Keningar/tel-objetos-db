CREATE  FORCE VIEW "NAF47_TNET"."ARPLTACOM" ("NO_CIA", "CODIGO", "DESCRIPCION", "TIEMPO_PARCIAL") AS 
  SELECT "NO_CIA",
           "CODIGO",
           "DESCRIPCION",
           "TIEMPO_PARCIAL"
      FROM NAF47_TNET.ARPLTACOM@GPOETNET;