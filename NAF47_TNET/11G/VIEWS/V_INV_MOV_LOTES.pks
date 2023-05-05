CREATE  FORCE VIEW "NAF47_TNET"."V_INV_MOV_LOTES" ("NO_CIA", "CENTRO", "TIPO_DOC", "ANO", "RUTA", "NO_DOCU", "NO_LINEA", "BODEGA", "NO_ARTI", "COSTO_UNI", "FECHA", "COSTO2", "TIPO_REFE", "NO_REFE", "TIME_STAMP", "NO_LOTE", "UNIDADES") AS 
  SELECT "NO_CIA",
           "CENTRO",
           "TIPO_DOC",
           "ANO",
           "RUTA",
           "NO_DOCU",
           "NO_LINEA",
           "BODEGA",
           "NO_ARTI",
           "COSTO_UNI",
           "FECHA",
           "COSTO2",
           "TIPO_REFE",
           "NO_REFE",
           "TIME_STAMP",
           "NO_LOTE",
           "UNIDADES"
      FROM NAF47_TNET.V_INV_MOV_LOTES@GPOETNET;