CREATE  FORCE VIEW "NAF47_TNET"."PL_ASISTENCIAS" ("NO_CIA", "ID_CODIGO", "CODPLA", "NO_HORA", "LOCALIDAD", "FECHA", "ESTADO") AS 
  SELECT "NO_CIA",
           "ID_CODIGO",
           "CODPLA",
           "NO_HORA",
           "LOCALIDAD",
           "FECHA",
           "ESTADO"
      FROM NAF47_TNET.PL_ASISTENCIAS@GPOETNET;