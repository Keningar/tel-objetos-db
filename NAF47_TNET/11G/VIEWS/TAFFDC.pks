CREATE  FORCE VIEW "NAF47_TNET"."TAFFDC" ("NO_CIA", "TRANSA_ID", "CONSECUTIVO_DC", "NO_DOCU", "CTA_CONTABLE", "NATURALEZA", "CENTRO_COSTO", "MONEDA", "TIPO_CAMBIO", "MONTO", "ANO_CONTA", "MES_CONTA", "NO_ASIENTO", "MODIFICABLE", "ESTADO", "GLOSA") AS 
  SELECT "NO_CIA",
           "TRANSA_ID",
           "CONSECUTIVO_DC",
           "NO_DOCU",
           "CTA_CONTABLE",
           "NATURALEZA",
           "CENTRO_COSTO",
           "MONEDA",
           "TIPO_CAMBIO",
           "MONTO",
           "ANO_CONTA",
           "MES_CONTA",
           "NO_ASIENTO",
           "MODIFICABLE",
           "ESTADO",
           "GLOSA"
      FROM NAF47_TNET.TAFFDC@GPOETNET;