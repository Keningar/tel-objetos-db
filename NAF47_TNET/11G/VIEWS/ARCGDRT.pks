CREATE  FORCE VIEW "NAF47_TNET"."ARCGDRT" ("NO_CIA", "CODIGO_RELACION", "CLAVE", "CLAVE_RETENCION") AS 
  SELECT "NO_CIA",
           "CODIGO_RELACION",
           "CLAVE",
           "CLAVE_RETENCION"
      FROM NAF47_TNET.ARCGDRT@GPOETNET;