CREATE  FORCE VIEW "NAF47_TNET"."ARIMPROVEGASTO" ("NO_CIA", "NUM_FAC", "CODIGO", "NO_PROVE") AS 
  SELECT "NO_CIA",
           "NUM_FAC",
           "CODIGO",
           "NO_PROVE"
      FROM NAF47_TNET.ARIMPROVEGASTO@GPOETNET;