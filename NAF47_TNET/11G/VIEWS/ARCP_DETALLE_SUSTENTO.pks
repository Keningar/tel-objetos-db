CREATE  FORCE VIEW "NAF47_TNET"."ARCP_DETALLE_SUSTENTO" ("NO_CIA", "NO_DOCU", "COD_SUSTENTO", "BASE_GRAVADO", "BASE_IMPONIBLE", "IVA", "USR_CREACION", "FE_CREACION", "USR_ACTUALIZA", "FE_ACTUALIZA") AS 
  SELECT "NO_CIA",
           "NO_DOCU",
           "COD_SUSTENTO",
           "BASE_GRAVADO",
           "BASE_IMPONIBLE",
           "IVA",
           "USR_CREACION",
           "FE_CREACION",
           "USR_ACTUALIZA",
           "FE_ACTUALIZA"
      FROM NAF47_TNET.ARCP_DETALLE_SUSTENTO@GPOETNET;