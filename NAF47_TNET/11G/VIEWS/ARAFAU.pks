CREATE  FORCE VIEW "NAF47_TNET"."ARAFAU" ("NO_CIA", "CUENTA", "DEBITOS", "CREDITOS", "CENT_COST", "CREDITOS_DOL", "DEBITOS_DOL") AS 
  SELECT "NO_CIA",
           "CUENTA",
           "DEBITOS",
           "CREDITOS",
           "CENT_COST",
           "CREDITOS_DOL",
           "DEBITOS_DOL"
      FROM NAF47_TNET.ARAFAU@GPOETNET;