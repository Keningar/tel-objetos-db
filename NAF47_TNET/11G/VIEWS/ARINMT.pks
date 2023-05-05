CREATE  FORCE VIEW "NAF47_TNET"."ARINMT" ("NO_CIA", "CENTRO", "TIPO_DOC", "ANO", "RUTA", "NO_DOCU", "NO_LINEA", "NO_LOTE", "BODEGA", "NO_ARTI", "UNIDADES", "VENTA", "DESCUENTO") AS 
  SELECT "NO_CIA",
           "CENTRO",
           "TIPO_DOC",
           "ANO",
           "RUTA",
           "NO_DOCU",
           "NO_LINEA",
           "NO_LOTE",
           "BODEGA",
           "NO_ARTI",
           "UNIDADES",
           "VENTA",
           "DESCUENTO"
      FROM NAF47_TNET.ARINMT@GPOETNET;