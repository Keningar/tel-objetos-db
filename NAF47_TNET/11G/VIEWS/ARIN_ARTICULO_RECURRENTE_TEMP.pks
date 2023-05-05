
CREATE  FORCE VIEW "NAF47_TNET"."ARIN_ARTICULO_RECURRENTE_TEMP" ("ID_EMPRESA", "ID_ARTICULO", "ID_REGION", "CANTIDAD_MINIMA", "CANTIDAD_MAXIMA", "MES", "ANIO", "ESTADO", "OBSERVACION", "USR_CREACION", "FECHA_CREACION", "USR_ULT_MOD", "FECHA_ULT_MOD", "SEMANA") AS 
  SELECT "ID_EMPRESA",
           "ID_ARTICULO",
           "ID_REGION",
           "CANTIDAD_MINIMA",
           "CANTIDAD_MAXIMA",
           "MES",
           "ANIO",
           "ESTADO",
           "OBSERVACION",
           "USR_CREACION",
           "FECHA_CREACION",
           "USR_ULT_MOD",
           "FECHA_ULT_MOD",
           "SEMANA"
      FROM NAF47_TNET.ARIN_ARTICULO_RECURRENTE_TEMP@GPOETNET;