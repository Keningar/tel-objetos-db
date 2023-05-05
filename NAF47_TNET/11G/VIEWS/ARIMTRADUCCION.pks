CREATE  FORCE VIEW "NAF47_TNET"."ARIMTRADUCCION" ("NO_CIA", "NUM_FAC", "NO_FISICO", "ORDEN", "NO_ARTI", "CANTIDAD_PEDIDA", "TRADUCCION", "NO_PROVE", "NOM_PROVE") AS 
  SELECT "NO_CIA",
           "NUM_FAC",
           "NO_FISICO",
           "ORDEN",
           "NO_ARTI",
           "CANTIDAD_PEDIDA",
           "TRADUCCION",
           "NO_PROVE",
           "NOM_PROVE"
      FROM NAF47_TNET.ARIMTRADUCCION@GPOETNET;