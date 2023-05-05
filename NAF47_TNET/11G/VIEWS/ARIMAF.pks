CREATE  FORCE VIEW "NAF47_TNET"."ARIMAF" ("NO_CIA", "COD_AF", "NOMBRE", "DIRECCION", "TELEFONO", "FAX", "CONTACTO", "NO_PROVE") AS 
  SELECT "NO_CIA",
           "COD_AF",
           "NOMBRE",
           "DIRECCION",
           "TELEFONO",
           "FAX",
           "CONTACTO",
           "NO_PROVE"
      FROM NAF47_TNET.ARIMAF@GPOETNET;