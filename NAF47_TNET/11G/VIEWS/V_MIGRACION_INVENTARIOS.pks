CREATE  FORCE VIEW "NAF47_TNET"."V_MIGRACION_INVENTARIOS" ("NO_CIA", "TIPO_DOC", "NO_FISICO", "FECHA", "BODEGA", "NO_ARTI", "UNIDADES", "ORIGEN", "TRANSAC", "PRECIO") AS 
  SELECT "NO_CIA",
           "TIPO_DOC",
           "NO_FISICO",
           "FECHA",
           "BODEGA",
           "NO_ARTI",
           "UNIDADES",
           "ORIGEN",
           "TRANSAC",
           "PRECIO"
      FROM NAF47_TNET.V_MIGRACION_INVENTARIOS@GPOETNET;