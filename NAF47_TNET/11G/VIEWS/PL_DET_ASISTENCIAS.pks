CREATE  FORCE VIEW "NAF47_TNET"."PL_DET_ASISTENCIAS" ("NO_CIA", "ID_CODIGO", "NO_EMPLE", "F_ENTRADA", "H_ENTRADA", "F_SALIDA", "H_SALIDA", "TRABAJADAS", "ORDINARIAS", "SUPLEMEN", "EXTRAS", "NOCTURNO", "NOLABO", "AUTO_SUPLE", "AUTO_EXTRA") AS 
  SELECT "NO_CIA",
           "ID_CODIGO",
           "NO_EMPLE",
           "F_ENTRADA",
           "H_ENTRADA",
           "F_SALIDA",
           "H_SALIDA",
           "TRABAJADAS",
           "ORDINARIAS",
           "SUPLEMEN",
           "EXTRAS",
           "NOCTURNO",
           "NOLABO",
           "AUTO_SUPLE",
           "AUTO_EXTRA"
      FROM NAF47_TNET.PL_DET_ASISTENCIAS@GPOETNET;