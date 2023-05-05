CREATE  FORCE VIEW "NAF47_TNET"."ARIMLOTES" ("NO_CIA", "CENTRO", "TIPO_DOC", "PERIODO", "RUTA", "NO_DOCU", "LINEA", "NO_LOTE", "UNIDADES", "MONTO", "DESCUENTO_L", "IMP_VENTAS_L", "UBICACION", "FECHA_VENCE", "FECHA_CONSOLI", "FECHA_MATRIZ", "NO_ARTI") AS 
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
           "FECHA_VENCE",
           "FECHA_CONSOLI",
           "FECHA_MATRIZ",
           "NO_ARTI"
      FROM NAF47_TNET.ARIMLOTES@GPOETNET;