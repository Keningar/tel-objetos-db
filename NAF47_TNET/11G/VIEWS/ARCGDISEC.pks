CREATE  FORCE VIEW "NAF47_TNET"."ARCGDISEC" ("NO_CIA", "CLAVE", "ID_SEC", "SECTOR", "ACTIVIDAD", "PAIS", "PROVINCIA", "CANTON", "PORCENTAJE", "BASE_MINIMA", "CUENTA_CONTABLE", "FEC_DESDE") AS 
  SELECT "NO_CIA",
           "CLAVE",
           "ID_SEC",
           "SECTOR",
           "ACTIVIDAD",
           "PAIS",
           "PROVINCIA",
           "CANTON",
           "PORCENTAJE",
           "BASE_MINIMA",
           "CUENTA_CONTABLE",
           "FEC_DESDE"
      FROM NAF47_TNET.ARCGDISEC@GPOETNET;