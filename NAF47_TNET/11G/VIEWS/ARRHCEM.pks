CREATE  FORCE VIEW "NAF47_TNET"."ARRHCEM" ("NO_CIA", "NO_EMPLE", "TIPO_EMP", "AREA", "DEPTO", "DIVISION", "SECCION", "PUESTO", "CENTRO_COSTO", "ID_PROVINCIA", "SAL_BAS", "ID_REGION_PATRONAL", "FECHA_CAMBIO", "USER_CAMBIO") AS 
  SELECT "NO_CIA",
           "NO_EMPLE",
           "TIPO_EMP",
           "AREA",
           "DEPTO",
           "DIVISION",
           "SECCION",
           "PUESTO",
           "CENTRO_COSTO",
           "ID_PROVINCIA",
           "SAL_BAS",
           "ID_REGION_PATRONAL",
           "FECHA_CAMBIO",
           "USER_CAMBIO"
      FROM NAF47_TNET.ARRHCEM@GPOETNET;