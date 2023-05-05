CREATE  FORCE VIEW "NAF47_TNET"."RESPALDO_TAFFDC" ("NO_CIA", "TRANSA_ID", "CONSECUTIVO_DC", "NO_DOCU", "CTA_CONTABLE", "NATURALEZA", "CENTRO_COSTO", "MONEDA", "TIPO_CAMBIO", "MONTO", "ANO_CONTA", "MES_CONTA", "NO_ASIENTO", "MODIFICABLE", "ESTADO") AS 
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
           "ESTADO"
      FROM NAF47_TNET.RESPALDO_TAFFDC@GPOETNET;