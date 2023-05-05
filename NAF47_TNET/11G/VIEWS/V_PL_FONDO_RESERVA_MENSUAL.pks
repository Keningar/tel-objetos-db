CREATE  FORCE VIEW "NAF47_TNET"."V_PL_FONDO_RESERVA_MENSUAL" ("NO_CIA", "COD_PLA", "NO_EMPLE", "NOMBRE", "NO_INGRE", "CENTRO_COSTO", "IND_FDO_RES", "MONTO", "CEDULA", "TIPO") AS 
  SELECT "NO_CIA",
           "COD_PLA",
           "NO_EMPLE",
           "NOMBRE",
           "NO_INGRE",
           "CENTRO_COSTO",
           "IND_FDO_RES",
           "MONTO",
           "CEDULA",
           "TIPO"
      FROM NAF47_TNET.V_PL_FONDO_RESERVA_MENSUAL@GPOETNET;