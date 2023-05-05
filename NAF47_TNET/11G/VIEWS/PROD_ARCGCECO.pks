CREATE  FORCE VIEW "NAF47_TNET"."PROD_ARCGCECO" ("NO_CIA", "CC_1", "CC_2", "CC_3", "DESCRIP_CC", "ENCARGADO_CC", "CENTRO", "ULTIMO_NIVEL") AS 
  SELECT "NO_CIA",
           "CC_1",
           "CC_2",
           "CC_3",
           "DESCRIP_CC",
           "ENCARGADO_CC",
           "CENTRO",
           "ULTIMO_NIVEL"
      FROM NAF47_TNET.PROD_ARCGCECO@GPOETNET;