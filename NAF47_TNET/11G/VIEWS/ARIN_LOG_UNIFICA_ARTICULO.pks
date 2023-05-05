CREATE  FORCE VIEW "NAF47_TNET"."ARIN_LOG_UNIFICA_ARTICULO" ("NO_CIA", "NO_ARTI", "NO_ARTI_NUEVO", "ESTRUCTURA", "LLAVE_PRIMARIA", "UPDATE_REVERSO", "USR_CRECION", "FE_CREACION", "ESTADO") AS 
  SELECT "NO_CIA",
           "NO_ARTI",
           "NO_ARTI_NUEVO",
           "ESTRUCTURA",
           "LLAVE_PRIMARIA",
           "UPDATE_REVERSO",
           "USR_CRECION",
           "FE_CREACION",
           "ESTADO"
      FROM NAF47_TNET.ARIN_LOG_UNIFICA_ARTICULO@GPOETNET;