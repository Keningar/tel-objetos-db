CREATE  FORCE VIEW "NAF47_TNET"."ARIMDETEMBARQUE" ("NO_CIA", "NO_EMBARQUE", "NO_ORDEN", "NO_PROFORMA", "NO_PROVE") AS 
  SELECT "NO_CIA",
           "NO_EMBARQUE",
           "NO_ORDEN",
           "NO_PROFORMA",
           "NO_PROVE"
      FROM NAF47_TNET.ARIMDETEMBARQUE@GPOETNET;