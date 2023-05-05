CREATE  FORCE VIEW "NAF47_TNET"."ARINHC" ("NO_CIA", "CENTRO", "ANO", "SEMANA", "IND_SEM", "NO_ARTI", "CENTRO_COSTO", "UNIDADES", "MONTO") AS 
  SELECT "NO_CIA",
           "CENTRO",
           "ANO",
           "SEMANA",
           "IND_SEM",
           "NO_ARTI",
           "CENTRO_COSTO",
           "UNIDADES",
           "MONTO"
      FROM NAF47_TNET.ARINHC@GPOETNET;