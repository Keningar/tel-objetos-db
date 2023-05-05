CREATE  FORCE VIEW "NAF47_TNET"."V_EMPRESAS_GRUPO" ("NO_CIA", "NOMBRE", "NOMBRE_LARGO", "RAZON_SOCIAL", "ID_TRIBUTARIO", "REPRE", "DIRECCION", "TELEFONO", "FAX", "E_MAIL") AS 
  SELECT "NO_CIA",
           "NOMBRE",
           "NOMBRE_LARGO",
           "RAZON_SOCIAL",
           "ID_TRIBUTARIO",
           "REPRE",
           "DIRECCION",
           "TELEFONO",
           "FAX",
           "E_MAIL"
      FROM NAF47_TNET.V_EMPRESAS_GRUPO@GPOETNET;