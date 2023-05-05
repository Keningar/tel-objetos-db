CREATE  FORCE VIEW "NAF47_TNET"."ARCGGRF" ("NO_CIA", "REP", "LINEA", "CUENTA", "CC_1", "CC_2", "CC_3", "CAMPO", "PORC") AS 
  SELECT "NO_CIA",
           "REP",
           "LINEA",
           "CUENTA",
           "CC_1",
           "CC_2",
           "CC_3",
           "CAMPO",
           "PORC"
      FROM NAF47_TNET.ARCGGRF@GPOETNET;