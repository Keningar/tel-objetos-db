CREATE  FORCE VIEW "NAF47_TNET"."ARRHSS" ("NO_CIA", "NO_SOLIC") AS 
  SELECT "NO_CIA", "NO_SOLIC" FROM NAF47_TNET.ARRHSS@GPOETNET;