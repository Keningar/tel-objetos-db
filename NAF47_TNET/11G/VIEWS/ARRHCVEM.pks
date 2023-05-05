
CREATE  FORCE VIEW "NAF47_TNET"."ARRHCVEM" ("NO_CIA", "NO_EMPLE", "HAB_INGLES", "ESC_INGLES", "LEE_INGLES", "HAB_FRANCES", "ESC_FRANCES", "LEE_FRANCES", "HAB_ALEMAN", "ESC_ALEMAN", "LEE_ALEMAN", "OTRO_IDIOMA", "ESC_OTRO", "HAB_OTRO", "LEE_OTRO") AS 
  SELECT "NO_CIA",
           "NO_EMPLE",
           "HAB_INGLES",
           "ESC_INGLES",
           "LEE_INGLES",
           "HAB_FRANCES",
           "ESC_FRANCES",
           "LEE_FRANCES",
           "HAB_ALEMAN",
           "ESC_ALEMAN",
           "LEE_ALEMAN",
           "OTRO_IDIOMA",
           "ESC_OTRO",
           "HAB_OTRO",
           "LEE_OTRO"
      FROM NAF47_TNET.ARRHCVEM@GPOETNET;