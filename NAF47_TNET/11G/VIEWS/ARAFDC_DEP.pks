CREATE  FORCE VIEW "NAF47_TNET"."ARAFDC_DEP" ("NO_CIA", "CODIGO", "CENTRO_COSTO", "TIPO", "ANO", "MES", "FECHA", "MONTO", "MONTO_DOL", "IND_CON", "NO_ASIENTO", "CODIGO_TERCERO") AS 
  SELECT "NO_CIA",
           "CODIGO",
           "CENTRO_COSTO",
           "TIPO",
           "ANO",
           "MES",
           "FECHA",
           "MONTO",
           "MONTO_DOL",
           "IND_CON",
           "NO_ASIENTO",
           "CODIGO_TERCERO"
      FROM NAF47_TNET.ARAFDC_DEP@GPOETNET;