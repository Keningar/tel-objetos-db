
CREATE  FORCE VIEW "NAF47_TNET"."ARRHCVE" ("NO_CIA", "NO_SOLIC", "NO_EMPLE", "EMPRESA", "TELEFONO", "CARGO", "DESDE_FECHA", "HASTA_FECHA", "ULT_SALARIO", "JEFE", "MOTIVO_SALIDA", "FUNCIONES") AS 
  SELECT "NO_CIA",
           "NO_SOLIC",
           "NO_EMPLE",
           "EMPRESA",
           "TELEFONO",
           "CARGO",
           "DESDE_FECHA",
           "HASTA_FECHA",
           "ULT_SALARIO",
           "JEFE",
           "MOTIVO_SALIDA",
           "FUNCIONES"
      FROM NAF47_TNET.ARRHCVE@GPOETNET;