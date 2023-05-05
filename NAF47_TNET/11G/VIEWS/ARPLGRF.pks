
CREATE  FORCE VIEW "NAF47_TNET"."ARPLGRF" ("NO_CIA", "NO_REP", "REF", "TIPO_M", "CODIGO", "TIPO_DATO", "PORC") AS 
  SELECT "NO_CIA",
           "NO_REP",
           "REF",
           "TIPO_M",
           "CODIGO",
           "TIPO_DATO",
           "PORC"
      FROM NAF47_TNET.ARPLGRF@GPOETNET;