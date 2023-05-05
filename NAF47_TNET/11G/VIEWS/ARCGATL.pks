CREATE  FORCE VIEW "NAF47_TNET"."ARCGATL" ("NO_CIA", "COD_ATIPO", "TIPO", "CUENTA", "CC_1", "CC_2", "CC_3", "CODIGO_TERCERO", "MONTO", "NO_LINEA", "PORCENTAJE", "DISTRIBUIR") AS 
  SELECT "NO_CIA",
           "COD_ATIPO",
           "TIPO",
           "CUENTA",
           "CC_1",
           "CC_2",
           "CC_3",
           "CODIGO_TERCERO",
           "MONTO",
           "NO_LINEA",
           "PORCENTAJE",
           "DISTRIBUIR"
      FROM NAF47_TNET.ARCGATL@GPOETNET;