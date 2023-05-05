CREATE  FORCE VIEW "NAF47_TNET"."ARINRI" ("NO_CIA", "CENTRO", "TIPO_DOC", "PERIODO", "RUTA", "NO_DOCU", "CLAVE", "PORCENTAJE", "MONTO", "IND_IMP_RET", "APLICA_CRED_FISCAL", "BASE", "CODIGO_TERCERO", "COMPORTAMIENTO", "ID_SEC") AS 
  SELECT "NO_CIA",
           "CENTRO",
           "TIPO_DOC",
           "PERIODO",
           "RUTA",
           "NO_DOCU",
           "CLAVE",
           "PORCENTAJE",
           "MONTO",
           "IND_IMP_RET",
           "APLICA_CRED_FISCAL",
           "BASE",
           "CODIGO_TERCERO",
           "COMPORTAMIENTO",
           "ID_SEC"
      FROM NAF47_TNET.ARINRI@GPOETNET;