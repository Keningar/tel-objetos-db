CREATE  FORCE VIEW "NAF47_TNET"."INV_REGULARIZACION_SERIES_RES" ("SERIE", "ARTICULO_NO", "ARTICULO_ANTERIOR", "OBSERVACION", "USUARIO_CREACION", "FECHA_CREACION") AS 
  SELECT "SERIE",
           "ARTICULO_NO",
           "ARTICULO_ANTERIOR",
           "OBSERVACION",
           "USUARIO_CREACION",
           "FECHA_CREACION"
      FROM NAF47_TNET.INV_REGULARIZACION_SERIES_RES@GPOETNET;