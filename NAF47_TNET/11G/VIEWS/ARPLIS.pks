CREATE  FORCE VIEW "NAF47_TNET"."ARPLIS" ("NO_CIA", "LIMITEINF", "LIMITESUP", "IMPUESTO_MIN", "PORCENTAJE") AS 
  SELECT "NO_CIA",
           "LIMITEINF",
           "LIMITESUP",
           "IMPUESTO_MIN",
           "PORCENTAJE"
      FROM NAF47_TNET.ARPLIS@GPOETNET;