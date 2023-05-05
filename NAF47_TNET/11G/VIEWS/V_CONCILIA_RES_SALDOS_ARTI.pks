CREATE  FORCE VIEW "NAF47_TNET"."V_CONCILIA_RES_SALDOS_ARTI" ("NO_CIA", "ANO", "MES", "CENTRO", "BODEGA", "NO_ARTI", "EXISTENCIA", "INICIA", "INGRESA", "SALIDA", "CIERRE") AS 
  SELECT "NO_CIA",
           "ANO",
           "MES",
           "CENTRO",
           "BODEGA",
           "NO_ARTI",
           "EXISTENCIA",
           "INICIA",
           "INGRESA",
           "SALIDA",
           "CIERRE"
      FROM NAF47_TNET.V_CONCILIA_RES_SALDOS_ARTI@GPOETNET;