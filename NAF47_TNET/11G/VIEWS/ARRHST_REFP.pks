
CREATE  FORCE VIEW "NAF47_TNET"."ARRHST_REFP" ("NO_CIA", "NO_SOLIC", "NOMBRE", "DIRECCION", "TLEFONO") AS 
  SELECT "NO_CIA",
           "NO_SOLIC",
           "NOMBRE",
           "DIRECCION",
           "TLEFONO"
      FROM NAF47_TNET.ARRHST_REFP@GPOETNET;