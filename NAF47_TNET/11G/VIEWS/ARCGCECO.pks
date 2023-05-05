CREATE  FORCE VIEW "NAF47_TNET"."ARCGCECO" ("NO_CIA", "CC_1", "CC_2", "CC_3", "DESCRIP_CC", "ENCARGADO_CC", "CENTRO", "ULTIMO_NIVEL", "TIPO_CENTRO", "IND_ACTIVO") AS 
  SELECT "NO_CIA",
           "CC_1",
           "CC_2",
           "CC_3",
           "DESCRIP_CC",
           "ENCARGADO_CC",
           "CENTRO",
           "ULTIMO_NIVEL",
           "TIPO_CENTRO",
           "IND_ACTIVO"
      FROM NAF47_TNET.ARCGCECO@GPOETNET;