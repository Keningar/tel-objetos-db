
CREATE  FORCE VIEW "NAF47_TNET"."ARRHTC" ("TIPO_CURSO", "DESCRI") AS 
  SELECT "TIPO_CURSO", "DESCRI" FROM NAF47_TNET.ARRHTC@GPOETNET;