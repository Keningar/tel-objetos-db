CREATE  FORCE VIEW "NAF47_TNET"."TAPBIENE" ("NO_CIA", "NO_SOLIC", "CENTRO_COSTO", "FECHA", "FECHA_VENCE", "ESTADO", "PRIORIDAD", "OBSERV", "NO_EMPLE", "NO_EMPLE_SOLIC", "CENTRO_COSTO_SOLIC", "IND_NO_INV", "BODEGA", "IND_AUTORIZADO", "MOTIVO_ANULACION", "TSTAMP", "USUARIO") AS 
  SELECT "NO_CIA",
           "NO_SOLIC",
           "CENTRO_COSTO",
           "FECHA",
           "FECHA_VENCE",
           "ESTADO",
           "PRIORIDAD",
           "OBSERV",
           "NO_EMPLE",
           "NO_EMPLE_SOLIC",
           "CENTRO_COSTO_SOLIC",
           "IND_NO_INV",
           "BODEGA",
           "IND_AUTORIZADO",
           "MOTIVO_ANULACION",
           "TSTAMP",
           "USUARIO"
      FROM NAF47_TNET.TAPBIENE@GPOETNET;