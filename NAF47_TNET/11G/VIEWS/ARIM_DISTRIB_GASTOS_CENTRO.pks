CREATE  FORCE VIEW "NAF47_TNET"."ARIM_DISTRIB_GASTOS_CENTRO" ("NO_CIA", "NO_PROVE", "CENTRO", "CENTRO_COSTO", "PORC_DISTRIB") AS 
  SELECT "NO_CIA",
           "NO_PROVE",
           "CENTRO",
           "CENTRO_COSTO",
           "PORC_DISTRIB"
      FROM NAF47_TNET.ARIM_DISTRIB_GASTOS_CENTRO@GPOETNET;