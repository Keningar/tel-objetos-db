
CREATE  FORCE VIEW "NAF47_TNET"."ARIMCALFACTU" ("NO_CIA", "NUM_FAC", "TIPO_GASTO", "NO_ARTI", "NO_LINEA", "TARIFA", "PESO_GASTO", "CUBI_GASTO", "MONTO") AS 
  SELECT "NO_CIA",
           "NUM_FAC",
           "TIPO_GASTO",
           "NO_ARTI",
           "NO_LINEA",
           "TARIFA",
           "PESO_GASTO",
           "CUBI_GASTO",
           "MONTO"
      FROM NAF47_TNET.ARIMCALFACTU@GPOETNET;