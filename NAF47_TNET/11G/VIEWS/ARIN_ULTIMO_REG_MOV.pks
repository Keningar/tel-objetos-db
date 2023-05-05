CREATE  FORCE VIEW "NAF47_TNET"."ARIN_ULTIMO_REG_MOV" ("NO_CIA", "NO_ARTI", "REGISTRO", "PROCESO", "BODEGA", "TIPO_DOC", "DESCRI", "UNIDADES", "COSTO_UNI", "USUARIO", "NO_DOCU", "OBSERV1") AS 
  SELECT "NO_CIA",
           "NO_ARTI",
           "REGISTRO",
           "PROCESO",
           "BODEGA",
           "TIPO_DOC",
           "DESCRI",
           "UNIDADES",
           "COSTO_UNI",
           "USUARIO",
           "NO_DOCU",
           "OBSERV1"
      FROM NAF47_TNET.ARIN_ULTIMO_REG_MOV@GPOETNET;