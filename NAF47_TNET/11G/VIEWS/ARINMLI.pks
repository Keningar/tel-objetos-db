CREATE  FORCE VIEW "NAF47_TNET"."ARINMLI" ("NO_CIA", "NO_DOCU", "LINEA", "CLAVE", "MONTO", "BASE", "CODIGO_TERCERO", "PORCENTAJE", "ID_SEC") AS 
  SELECT "NO_CIA",
           "NO_DOCU",
           "LINEA",
           "CLAVE",
           "MONTO",
           "BASE",
           "CODIGO_TERCERO",
           "PORCENTAJE",
           "ID_SEC"
      FROM NAF47_TNET.ARINMLI@GPOETNET;