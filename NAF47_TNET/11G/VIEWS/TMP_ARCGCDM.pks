CREATE  FORCE VIEW "NAF47_TNET"."TMP_ARCGCDM" ("NO_CIA", "COD_DIARIO", "MODULO", "FORMULARIO_CTRL") AS 
  SELECT "NO_CIA",
           "COD_DIARIO",
           "MODULO",
           "FORMULARIO_CTRL"
      FROM NAF47_TNET.TMP_ARCGCDM@GPOETNET;