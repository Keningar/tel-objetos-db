CREATE  FORCE VIEW "NAF47_TNET"."TAPORDREC" ("NO_CIA", "ORDEN", "LINEA", "FECHA_REC", "CANTIDAD", "TSTAMP", "USUARIO") AS 
  SELECT "NO_CIA",
           "ORDEN",
           "LINEA",
           "FECHA_REC",
           "CANTIDAD",
           "TSTAMP",
           "USUARIO"
      FROM NAF47_TNET.TAPORDREC@GPOETNET;