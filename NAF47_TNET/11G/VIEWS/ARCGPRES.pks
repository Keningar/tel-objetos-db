CREATE  FORCE VIEW "NAF47_TNET"."ARCGPRES" ("NO_CIA", "CUENTA", "CENTRO_C", "MODULO", "VAL_TRANS", "VAL_IN", "VAL_CK", "VAL_CP", "VAL_CC", "VAL_FF", "VAL_PL", "VAL_AF", "VAL_PRES") AS 
  SELECT "NO_CIA",
           "CUENTA",
           "CENTRO_C",
           "MODULO",
           "VAL_TRANS",
           "VAL_IN",
           "VAL_CK",
           "VAL_CP",
           "VAL_CC",
           "VAL_FF",
           "VAL_PL",
           "VAL_AF",
           "VAL_PRES"
      FROM NAF47_TNET.ARCGPRES@GPOETNET;