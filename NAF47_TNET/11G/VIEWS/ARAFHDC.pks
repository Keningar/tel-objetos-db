CREATE  FORCE VIEW "NAF47_TNET"."ARAFHDC" ("NO_CIA", "ANO", "MES", "CODIGO", "FECHA", "HORA", "TIPO_M", "TIPO", "MONTO", "MONTO_DOL", "IND_CON", "NO_ASIENTO", "CENTRO_COSTO", "NO_DOCU") AS 
  SELECT "NO_CIA",
           "ANO",
           "MES",
           "CODIGO",
           "FECHA",
           "HORA",
           "TIPO_M",
           "TIPO",
           "MONTO",
           "MONTO_DOL",
           "IND_CON",
           "NO_ASIENTO",
           "CENTRO_COSTO",
           "NO_DOCU"
      FROM NAF47_TNET.ARAFHDC@GPOETNET;