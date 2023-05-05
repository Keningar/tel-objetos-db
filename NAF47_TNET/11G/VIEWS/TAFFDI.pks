CREATE  FORCE VIEW "NAF47_TNET"."TAFFDI" ("NO_CIA", "TRANSA_ID", "NO_LINEA", "CLAVE", "PORCENTAJE", "MONTO", "IND_IMP_RET", "APLICA_CRED_FISCAL", "NO_PROVE", "BASE", "COMPORTAMIENTO", "ID_SEC") AS 
  SELECT "NO_CIA",
           "TRANSA_ID",
           "NO_LINEA",
           "CLAVE",
           "PORCENTAJE",
           "MONTO",
           "IND_IMP_RET",
           "APLICA_CRED_FISCAL",
           "NO_PROVE",
           "BASE",
           "COMPORTAMIENTO",
           "ID_SEC"
      FROM NAF47_TNET.TAFFDI@GPOETNET;