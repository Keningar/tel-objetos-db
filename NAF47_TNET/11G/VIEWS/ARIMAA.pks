
CREATE  FORCE VIEW "NAF47_TNET"."ARIMAA" ("NO_CIA", "COD_AGEN", "NOMBRE", "DIRECCION", "TELEFONO", "FAX", "CONTACTO", "NO_PROVE") AS 
  SELECT "NO_CIA",
           "COD_AGEN",
           "NOMBRE",
           "DIRECCION",
           "TELEFONO",
           "FAX",
           "CONTACTO",
           "NO_PROVE"
      FROM NAF47_TNET.ARIMAA@GPOETNET;