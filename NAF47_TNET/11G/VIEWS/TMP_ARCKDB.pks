CREATE  FORCE VIEW "NAF47_TNET"."TMP_ARCKDB" ("NO_CIA", "BANCO", "TIPO_DOCB", "TIPO_DOCC", "FORMA_CONCILIACION") AS 
  SELECT "NO_CIA",
           "BANCO",
           "TIPO_DOCB",
           "TIPO_DOCC",
           "FORMA_CONCILIACION"
      FROM NAF47_TNET.TMP_ARCKDB@GPOETNET;