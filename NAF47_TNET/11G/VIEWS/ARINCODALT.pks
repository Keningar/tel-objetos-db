CREATE  FORCE VIEW "NAF47_TNET"."ARINCODALT" ("NO_CIA", "COD_ALTERNO", "TIPO_COD", "NO_ARTI", "TSTAMP") AS 
  SELECT "NO_CIA",
           "COD_ALTERNO",
           "TIPO_COD",
           "NO_ARTI",
           "TSTAMP"
      FROM NAF47_TNET.ARINCODALT@GPOETNET;