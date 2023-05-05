CREATE  FORCE VIEW "NAF47_TNET"."ARINVEXIST_VALORIZADAS" ("COD_CIA", "CENTRO", "BODEGA", "MARCA", "DIVISION", "SUBDIVISION", "COD_ARTICULO", "DESCRIPC_ARTICULO", "EXIST_INICIO", "VALOR_INICIAL", "CANT_INGRESO", "VALOR_INGRESO", "CANT_EGRESO", "VALOR_EGRESO", "CATIDAD_FINAL", "VALOR_FINAL", "COSTO_PROMEDIO", "USUARIO") AS 
  SELECT "COD_CIA",
           "CENTRO",
           "BODEGA",
           "MARCA",
           "DIVISION",
           "SUBDIVISION",
           "COD_ARTICULO",
           "DESCRIPC_ARTICULO",
           "EXIST_INICIO",
           "VALOR_INICIAL",
           "CANT_INGRESO",
           "VALOR_INGRESO",
           "CANT_EGRESO",
           "VALOR_EGRESO",
           "CATIDAD_FINAL",
           "VALOR_FINAL",
           "COSTO_PROMEDIO",
           "USUARIO"
      FROM NAF47_TNET.ARINVEXIST_VALORIZADAS@GPOETNET;