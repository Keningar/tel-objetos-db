CREATE  FORCE VIEW "NAF47_TNET"."TMP_ARCGCD" ("NO_CIA", "COD_DIARIO", "DESCRIPCION") AS 
  SELECT "NO_CIA", "COD_DIARIO", "DESCRIPCION"
      FROM NAF47_TNET.TMP_ARCGCD@GPOETNET;