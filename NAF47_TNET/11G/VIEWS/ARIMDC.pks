
CREATE  FORCE VIEW "NAF47_TNET"."ARIMDC" ("NO_CIA", "NO_DOCU", "TIPO_DOC", "TIPO_MOV", "COD_CONT", "CENTRO_COSTO", "MONEDA", "MONTO", "MONTO_DOL", "TIPO_CAMBIO", "ANO_PROCE", "MES_PROCE", "IND_CON", "NO_ASIENTO", "GLOSA") AS 
  SELECT "NO_CIA",
           "NO_DOCU",
           "TIPO_DOC",
           "TIPO_MOV",
           "COD_CONT",
           "CENTRO_COSTO",
           "MONEDA",
           "MONTO",
           "MONTO_DOL",
           "TIPO_CAMBIO",
           "ANO_PROCE",
           "MES_PROCE",
           "IND_CON",
           "NO_ASIENTO",
           "GLOSA"
      FROM NAF47_TNET.ARIMDC@GPOETNET;