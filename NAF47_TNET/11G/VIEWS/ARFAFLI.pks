CREATE  FORCE VIEW "NAF47_TNET"."ARFAFLI" ("NO_CIA", "TIPO_DOC", "NO_FACTU", "NO_LINEA", "CLAVE", "PORC_IMP", "MONTO_IMP", "COLUMNA", "BASE", "CODIGO_TERCERO", "COMPORTAMIENTO", "APLICA_CRED_FISCAL", "ID_SEC") AS 
  SELECT "NO_CIA",
           "TIPO_DOC",
           "NO_FACTU",
           "NO_LINEA",
           "CLAVE",
           "PORC_IMP",
           "MONTO_IMP",
           "COLUMNA",
           "BASE",
           "CODIGO_TERCERO",
           "COMPORTAMIENTO",
           "APLICA_CRED_FISCAL",
           "ID_SEC"
      FROM NAF47_TNET.ARFAFLI@GPOETNET;