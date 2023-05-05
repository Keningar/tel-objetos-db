CREATE  FORCE VIEW "NAF47_TNET"."ARCSLAF" ("NO_CIA", "TIPO_ASIENTO", "COD_ASIENTO", "NO_LINEA", "CUENTA", "CEN_COS", "CONCEPTO", "TIPO_MOV", "MONTO") AS 
  SELECT "NO_CIA",
           "TIPO_ASIENTO",
           "COD_ASIENTO",
           "NO_LINEA",
           "CUENTA",
           "CEN_COS",
           "CONCEPTO",
           "TIPO_MOV",
           "MONTO"
      FROM NAF47_TNET.ARCSLAF@GPOETNET;