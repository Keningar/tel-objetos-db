CREATE  FORCE VIEW "NAF47_TNET"."ARINHA_REPROCESO" ("NO_CIA", "CENTRO", "ANO", "SEMANA", "IND_SEM", "BODEGA", "CLASE", "CATEGORIA", "NO_ARTI", "ULT_COSTO", "SALDO_UN", "SALDO_MO", "COSTO_UNI", "AJU_INI_REPROCESO", "ULT_COSTO2", "SALDO_MO2", "COSTO_UNI2") AS 
  SELECT "NO_CIA",
           "CENTRO",
           "ANO",
           "SEMANA",
           "IND_SEM",
           "BODEGA",
           "CLASE",
           "CATEGORIA",
           "NO_ARTI",
           "ULT_COSTO",
           "SALDO_UN",
           "SALDO_MO",
           "COSTO_UNI",
           "AJU_INI_REPROCESO",
           "ULT_COSTO2",
           "SALDO_MO2",
           "COSTO_UNI2"
      FROM NAF47_TNET.ARINHA_REPROCESO@GPOETNET;