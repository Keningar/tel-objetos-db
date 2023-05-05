CREATE  FORCE VIEW "NAF47_TNET"."V_CONCILIA_DET_SALDOS_ARTI" ("NO_CIA", "ANO", "MES", "CENTRO", "BODEGA", "NO_ARTI", "NIVEL", "TIPO_DOC", "DESCRIPCION", "UNIDADES") AS 
  SELECT "NO_CIA",
           "ANO",
           "MES",
           "CENTRO",
           "BODEGA",
           "NO_ARTI",
           "NIVEL",
           "TIPO_DOC",
           "DESCRIPCION",
           "UNIDADES"
      FROM NAF47_TNET.V_CONCILIA_DET_SALDOS_ARTI@GPOETNET;