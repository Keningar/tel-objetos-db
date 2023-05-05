CREATE  FORCE VIEW "NAF47_TNET"."TAPCOTIE" ("NO_CIA", "NO_COTIZ", "FECHA", "FECHA_VENCE", "NO_PROVE", "OBSERV", "ADJUDICADOR", "TSTAMP", "USUARIO", "BODEGA", "IND_NO_INV") AS 
  SELECT "NO_CIA",
           "NO_COTIZ",
           "FECHA",
           "FECHA_VENCE",
           "NO_PROVE",
           "OBSERV",
           "ADJUDICADOR",
           "TSTAMP",
           "USUARIO",
           "BODEGA",
           "IND_NO_INV"
      FROM NAF47_TNET.TAPCOTIE@GPOETNET;