CREATE  FORCE VIEW "NAF47_TNET"."ARINDEMANDA_ERRORI" ("NO_CIA", "BODEGA", "NO_ARTI", "FECHA", "DEMANDA", "VENTA", "CODIGO_ANTERIOR") AS 
  SELECT "NO_CIA",
           "BODEGA",
           "NO_ARTI",
           "FECHA",
           "DEMANDA",
           "VENTA",
           "CODIGO_ANTERIOR"
      FROM NAF47_TNET.ARINDEMANDA_ERRORI@GPOETNET;