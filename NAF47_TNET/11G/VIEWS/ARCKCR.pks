
CREATE  FORCE VIEW "NAF47_TNET"."ARCKCR" ("NO_CIA", "NO_CTA", "ACTUAL_CIA", "ACTUAL_BCO", "MONTO_CIA", "MONTO_BCO", "SAL_ANT", "SAL_ANT_B", "DEP_C", "DEP_B", "CHE_C", "CHE_B", "CRE_C", "CRE_B", "DEB_C", "DEB_B", "OBSERV") AS 
  SELECT "NO_CIA",
           "NO_CTA",
           "ACTUAL_CIA",
           "ACTUAL_BCO",
           "MONTO_CIA",
           "MONTO_BCO",
           "SAL_ANT",
           "SAL_ANT_B",
           "DEP_C",
           "DEP_B",
           "CHE_C",
           "CHE_B",
           "CRE_C",
           "CRE_B",
           "DEB_C",
           "DEB_B",
           "OBSERV"
      FROM NAF47_TNET.ARCKCR@GPOETNET;