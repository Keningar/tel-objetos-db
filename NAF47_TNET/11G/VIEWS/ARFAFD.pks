CREATE  FORCE VIEW "NAF47_TNET"."ARFAFD" ("NO_CIA", "CENTROD", "CENTROF", "TIPO_DOC", "ID_CAMPO", "LINEA", "COLUMNA", "TAMANO", "VALOR_DEFAULT") AS 
  SELECT "NO_CIA",
           "CENTROD",
           "CENTROF",
           "TIPO_DOC",
           "ID_CAMPO",
           "LINEA",
           "COLUMNA",
           "TAMANO",
           "VALOR_DEFAULT"
      FROM NAF47_TNET.ARFAFD@GPOETNET;