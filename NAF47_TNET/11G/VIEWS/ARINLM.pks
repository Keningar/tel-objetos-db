CREATE  FORCE VIEW "NAF47_TNET"."ARINLM" ("NO_CIA", "CENTRO", "TIPO_DOC", "PERIODO", "NO_DOCU", "BODEGA", "NO_ARTI", "COSTO_UNITARIO", "CANTIDAD", "DESPACHADO") AS 
  SELECT "NO_CIA",
           "CENTRO",
           "TIPO_DOC",
           "PERIODO",
           "NO_DOCU",
           "BODEGA",
           "NO_ARTI",
           "COSTO_UNITARIO",
           "CANTIDAD",
           "DESPACHADO"
      FROM NAF47_TNET.ARINLM@GPOETNET;