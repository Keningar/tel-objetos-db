CREATE  FORCE VIEW "NAF47_TNET"."PRESENTACION" ("NO_CIA", "NO_PRESENTACION", "DESCRIPCION") AS 
  SELECT "NO_CIA", "NO_PRESENTACION", "DESCRIPCION"
      FROM NAF47_TNET.PRESENTACION@GPOETNET;