
CREATE  FORCE VIEW "NAF47_TNET"."ARIMAUDITORIA" ("NO_CIA", "SECUENCIA", "FECHA", "HORA", "USUARIO", "APLICACION", "COMENTARIO") AS 
  SELECT "NO_CIA",
           "SECUENCIA",
           "FECHA",
           "HORA",
           "USUARIO",
           "APLICACION",
           "COMENTARIO"
      FROM NAF47_TNET.ARIMAUDITORIA@GPOETNET;