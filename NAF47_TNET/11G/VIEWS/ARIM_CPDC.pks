CREATE  FORCE VIEW "NAF47_TNET"."ARIM_CPDC" ("NO_CIA", "NO_PROVE", "TIPO_DOC", "NO_DOCU", "CODIGO", "TIPO", "MONTO", "MES", "ANO", "IND_CON", "MONTO_DOL", "MONEDA", "TIPO_CAMBIO", "NO_ASIENTO", "CENTRO_COSTO", "MODIFICABLE", "CODIGO_TERCERO", "MONTO_DC", "GLOSA") AS 
  SELECT "NO_CIA",
           "NO_PROVE",
           "TIPO_DOC",
           "NO_DOCU",
           "CODIGO",
           "TIPO",
           "MONTO",
           "MES",
           "ANO",
           "IND_CON",
           "MONTO_DOL",
           "MONEDA",
           "TIPO_CAMBIO",
           "NO_ASIENTO",
           "CENTRO_COSTO",
           "MODIFICABLE",
           "CODIGO_TERCERO",
           "MONTO_DC",
           "GLOSA"
      FROM NAF47_TNET.ARIM_CPDC@GPOETNET;