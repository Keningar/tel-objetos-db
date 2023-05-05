CREATE  FORCE VIEW "NAF47_TNET"."ARINDC" ("NO_CIA", "CENTRO", "TIPO_DOC", "NO_DOCU", "CUENTA", "CENTRO_COSTO", "TIPO_MOV", "MONTO", "TIPO_CAMBIO", "MONTO_DOL", "ANO", "MES", "NO_ASIENTO", "IND_GEN", "IND_REPROCESO", "CODIGO_TERCERO") AS 
  SELECT "NO_CIA",
           "CENTRO",
           "TIPO_DOC",
           "NO_DOCU",
           "CUENTA",
           "CENTRO_COSTO",
           "TIPO_MOV",
           "MONTO",
           "TIPO_CAMBIO",
           "MONTO_DOL",
           "ANO",
           "MES",
           "NO_ASIENTO",
           "IND_GEN",
           "IND_REPROCESO",
           "CODIGO_TERCERO"
      FROM NAF47_TNET.ARINDC@GPOETNET;