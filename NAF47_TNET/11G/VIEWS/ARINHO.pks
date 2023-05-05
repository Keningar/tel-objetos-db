CREATE  FORCE VIEW "NAF47_TNET"."ARINHO" ("NO_CIA", "CENTRO", "ANO", "SEMANA", "IND_SEM", "NO_PROVE", "NO_ARTI", "UNIDADES", "MONTO") AS 
  SELECT "NO_CIA",
           "CENTRO",
           "ANO",
           "SEMANA",
           "IND_SEM",
           "NO_PROVE",
           "NO_ARTI",
           "UNIDADES",
           "MONTO"
      FROM NAF47_TNET.ARINHO@GPOETNET;