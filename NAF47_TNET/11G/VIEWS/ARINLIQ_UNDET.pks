CREATE  FORCE VIEW "NAF47_TNET"."ARINLIQ_UNDET" ("NO_CIA", "CENTRO", "AGENTE", "PERIODO", "NO_LIQUI", "FECHA", "BODEGA", "CLASE", "NO_ARTI", "IND_LIQUID", "ENTREGADAS", "APROBADAS", "PRECIO", "MONEDA") AS 
  SELECT "NO_CIA",
           "CENTRO",
           "AGENTE",
           "PERIODO",
           "NO_LIQUI",
           "FECHA",
           "BODEGA",
           "CLASE",
           "NO_ARTI",
           "IND_LIQUID",
           "ENTREGADAS",
           "APROBADAS",
           "PRECIO",
           "MONEDA"
      FROM NAF47_TNET.ARINLIQ_UNDET@GPOETNET;