CREATE  FORCE VIEW "NAF47_TNET"."V_EQUIPOS_TELCOS" ("ID_ELEMENTO", "NOMBRE_ELEMENTO", "NUMERO_SERIE", "ESTADO_ELEMENTO", "ID_PUNTO", "LOGIN", "NOMBRE_PUNTO", "ID_SERVICIO", "ESTADO_SERVICIO") AS 
  SELECT "ID_ELEMENTO",
           "NOMBRE_ELEMENTO",
           "NUMERO_SERIE",
           "ESTADO_ELEMENTO",
           "ID_PUNTO",
           "LOGIN",
           "NOMBRE_PUNTO",
           "ID_SERVICIO",
           "ESTADO_SERVICIO"
      FROM NAF47_TNET.V_EQUIPOS_TELCOS@GPOETNET;