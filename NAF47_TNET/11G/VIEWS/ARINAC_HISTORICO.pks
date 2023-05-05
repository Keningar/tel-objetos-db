CREATE  FORCE VIEW "NAF47_TNET"."ARINAC_HISTORICO" ("NO_CIA", "CENTRO", "BODEGA", "NO_ARTI", "MONTO_AJUSTE", "IND_AUTOMATICO", "MONTO2_AJUSTE", "COSTO_NUEVO", "COSTO2_NUEVO", "USUARIO_INGRESA", "FECHA_INGRESA", "COMENTARIO", "COD_MOTIVO", "COSTO_ARTI", "COSTO2_ARTI", "EXISTENCIA", "USUARIO_ACTUALIZA", "FECHA_ACTUALIZA", "NO_DOCU") AS 
  SELECT "NO_CIA",
           "CENTRO",
           "BODEGA",
           "NO_ARTI",
           "MONTO_AJUSTE",
           "IND_AUTOMATICO",
           "MONTO2_AJUSTE",
           "COSTO_NUEVO",
           "COSTO2_NUEVO",
           "USUARIO_INGRESA",
           "FECHA_INGRESA",
           "COMENTARIO",
           "COD_MOTIVO",
           "COSTO_ARTI",
           "COSTO2_ARTI",
           "EXISTENCIA",
           "USUARIO_ACTUALIZA",
           "FECHA_ACTUALIZA",
           "NO_DOCU"
      FROM NAF47_TNET.ARINAC_HISTORICO@GPOETNET;