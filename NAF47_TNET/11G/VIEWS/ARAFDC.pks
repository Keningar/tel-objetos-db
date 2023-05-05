CREATE  FORCE VIEW "NAF47_TNET"."ARAFDC" ("NO_CIA", "NO_DOCU", "CODIGO", "CENTRO_COSTO", "TIPO", "ANO", "MES", "FECHA", "HORA", "TIPO_M", "MONTO", "MONTO_DOL", "IND_CON", "NO_ASIENTO", "CODIGO_TERCERO", "MODIFICABLE") AS 
  SELECT "NO_CIA",
           "NO_DOCU",
           "CODIGO",
           "CENTRO_COSTO",
           "TIPO",
           "ANO",
           "MES",
           "FECHA",
           "HORA",
           "TIPO_M",
           "MONTO",
           "MONTO_DOL",
           "IND_CON",
           "NO_ASIENTO",
           "CODIGO_TERCERO",
           "MODIFICABLE"
      FROM NAF47_TNET.ARAFDC@GPOETNET;