
CREATE  FORCE VIEW "NAF47_TNET"."ARCGHD_CC" ("NO_CIA", "CUENTA", "CENTRO_COSTO", "ANO", "MES", "PORCENTAJE_D_CC", "MONTO_D_CC", "IND_COMO_DIST", "M_DIST_NOM", "M_DIST_DOL") AS 
  SELECT "NO_CIA",
           "CUENTA",
           "CENTRO_COSTO",
           "ANO",
           "MES",
           "PORCENTAJE_D_CC",
           "MONTO_D_CC",
           "IND_COMO_DIST",
           "M_DIST_NOM",
           "M_DIST_DOL"
      FROM NAF47_TNET.ARCGHD_CC@GPOETNET;