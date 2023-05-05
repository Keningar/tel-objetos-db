CREATE  FORCE VIEW "NAF47_TNET"."ARIMPISTAS" ("NO_CIA", "USUARIO", "CLAVE", "FECHA", "NO_FACTU", "NO_ORDEN", "NO_ARTI", "CANTIDAD", "ARTI_PROVE", "NO_PROVE", "PRECIO_OLD", "PRECIO_NEW", "OBSERVACION") AS 
  SELECT "NO_CIA",
           "USUARIO",
           "CLAVE",
           "FECHA",
           "NO_FACTU",
           "NO_ORDEN",
           "NO_ARTI",
           "CANTIDAD",
           "ARTI_PROVE",
           "NO_PROVE",
           "PRECIO_OLD",
           "PRECIO_NEW",
           "OBSERVACION"
      FROM NAF47_TNET.ARIMPISTAS@GPOETNET;