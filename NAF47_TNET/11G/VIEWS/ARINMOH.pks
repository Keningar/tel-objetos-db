CREATE  FORCE VIEW "NAF47_TNET"."ARINMOH" ("NO_CIA", "CENTRO", "TIPO_DOC", "PERIODO", "RUTA", "NO_DOCU", "LINEA", "NO_LOTE", "UNIDADES", "MONTO", "DESCUENTO_L", "IMP_VENTAS_L", "UBICACION", "FECHA_VENCE") AS 
  SELECT "NO_CIA",
           "CENTRO",
           "TIPO_DOC",
           "PERIODO",
           "RUTA",
           "NO_DOCU",
           "LINEA",
           "NO_LOTE",
           "UNIDADES",
           "MONTO",
           "DESCUENTO_L",
           "IMP_VENTAS_L",
           "UBICACION",
           "FECHA_VENCE"
      FROM NAF47_TNET.ARINMOH@GPOETNET;