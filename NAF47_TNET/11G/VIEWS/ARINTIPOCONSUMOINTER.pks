CREATE  FORCE VIEW "NAF47_TNET"."ARINTIPOCONSUMOINTER" ("NO_CIA", "CODIGO", "DESCRIPCION", "CUENTA", "CENTRO") AS 
  SELECT "NO_CIA",
           "CODIGO",
           "DESCRIPCION",
           "CUENTA",
           "CENTRO"
      FROM NAF47_TNET.ARINTIPOCONSUMOINTER@GPOETNET;