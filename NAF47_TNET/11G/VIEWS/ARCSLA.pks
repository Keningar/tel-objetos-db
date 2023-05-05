CREATE  FORCE VIEW "NAF47_TNET"."ARCSLA" ("NO_CIA", "ANO", "MES", "NO_ASIENTO", "NO_LINEA", "CONCEPTO", "CUENTA", "CEN_COS", "TIPO_MOV", "MONTO") AS 
  SELECT "NO_CIA",
           "ANO",
           "MES",
           "NO_ASIENTO",
           "NO_LINEA",
           "CONCEPTO",
           "CUENTA",
           "CEN_COS",
           "TIPO_MOV",
           "MONTO"
      FROM NAF47_TNET.ARCSLA@GPOETNET;