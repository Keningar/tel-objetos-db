CREATE  FORCE VIEW "NAF47_TNET"."ARPLDISE" ("NO_CIA", "CODIGO", "DIA_INI", "DIA_FIN") AS 
  SELECT "NO_CIA",
           "CODIGO",
           "DIA_INI",
           "DIA_FIN"
      FROM NAF47_TNET.ARPLDISE@GPOETNET;