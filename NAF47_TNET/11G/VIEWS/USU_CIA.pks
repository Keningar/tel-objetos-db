CREATE  FORCE VIEW "NAF47_TNET"."USU_CIA" ("NO_CIA", "ID_USU", "MODULO") AS 
  SELECT "NO_CIA", "ID_USU", "MODULO" FROM NAF47_TNET.USU_CIA@GPOETNET;