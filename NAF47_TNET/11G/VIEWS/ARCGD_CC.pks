CREATE  FORCE VIEW "NAF47_TNET"."ARCGD_CC" ("NO_CIA", "CUENTA", "CC_1", "CC_2", "CC_3", "PORCENTAJE_D_CC", "MONTO_D_CC", "IND_COMO_DIST", "M_DIST_NOM", "M_DIST_DOL") AS 
  SELECT "NO_CIA",
           "CUENTA",
           "CC_1",
           "CC_2",
           "CC_3",
           "PORCENTAJE_D_CC",
           "MONTO_D_CC",
           "IND_COMO_DIST",
           "M_DIST_NOM",
           "M_DIST_DOL"
      FROM NAF47_TNET.ARCGD_CC@GPOETNET;