CREATE  FORCE VIEW "NAF47_TNET"."TAPCOTID" ("NO_CIA", "NO_COTIZ", "NO_LINEA", "NO_ARTI", "MEDIDA", "DESCRIPCION", "COD_ART_PROV", "CANTIDAD", "ADJUDICADO", "COSTO_UNI", "CODIGO_NI") AS 
  SELECT "NO_CIA",
           "NO_COTIZ",
           "NO_LINEA",
           "NO_ARTI",
           "MEDIDA",
           "DESCRIPCION",
           "COD_ART_PROV",
           "CANTIDAD",
           "ADJUDICADO",
           "COSTO_UNI",
           "CODIGO_NI"
      FROM NAF47_TNET.TAPCOTID@GPOETNET;