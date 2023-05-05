
CREATE  FORCE VIEW "NAF47_TNET"."ARRHRL" ("NO_CIA", "NO_REQ", "NO_EMPLE", "NO_SOLIC", "FECHA", "EFECTIVO", "AUTORIZA", "SELECCIONA") AS 
  SELECT "NO_CIA",
           "NO_REQ",
           "NO_EMPLE",
           "NO_SOLIC",
           "FECHA",
           "EFECTIVO",
           "AUTORIZA",
           "SELECCIONA"
      FROM NAF47_TNET.ARRHRL@GPOETNET;