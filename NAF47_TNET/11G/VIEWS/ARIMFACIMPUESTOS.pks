CREATE  FORCE VIEW "NAF47_TNET"."ARIMFACIMPUESTOS" ("NO_CIA", "NUM_FAC", "CLAVE", "PORCENTAJE", "MONTO", "IND_IMP_RET", "APLICA_CRED_FISCAL", "BASE", "COMPORTAMIENTO", "ID_SEC") AS 
  SELECT "NO_CIA",
           "NUM_FAC",
           "CLAVE",
           "PORCENTAJE",
           "MONTO",
           "IND_IMP_RET",
           "APLICA_CRED_FISCAL",
           "BASE",
           "COMPORTAMIENTO",
           "ID_SEC"
      FROM NAF47_TNET.ARIMFACIMPUESTOS@GPOETNET;