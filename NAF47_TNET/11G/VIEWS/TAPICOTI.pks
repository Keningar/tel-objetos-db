CREATE  FORCE VIEW "NAF47_TNET"."TAPICOTI" ("NO_CIA", "NO_SOLIC", "NO_LINEA", "NO_PROVE", "ENCARGADO", "ELABORA_PEDIDO", "COSTO") AS 
  SELECT "NO_CIA",
           "NO_SOLIC",
           "NO_LINEA",
           "NO_PROVE",
           "ENCARGADO",
           "ELABORA_PEDIDO",
           "COSTO"
      FROM NAF47_TNET.TAPICOTI@GPOETNET;