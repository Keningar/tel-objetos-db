CREATE  FORCE VIEW "NAF47_TNET"."ARIN_CLASE_VENDEDOR" ("CLASE_VENDEDOR", "DESCRIPCION") AS 
  SELECT "CLASE_VENDEDOR", "DESCRIPCION"
      FROM NAF47_TNET.ARIN_CLASE_VENDEDOR@GPOETNET;