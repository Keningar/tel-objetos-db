CREATE  FORCE VIEW "NAF47_TNET"."ARPLCCSS" ("NO_CIA", "NO_EMPLE", "ANO", "MES", "NACION", "CEDULA", "NOMBRE", "SALARIO", "TIPO_C", "OBSERV", "TIPO_IDENT", "PUESTO", "APELLIDO1", "APELLIDO2") AS 
  SELECT "NO_CIA",
           "NO_EMPLE",
           "ANO",
           "MES",
           "NACION",
           "CEDULA",
           "NOMBRE",
           "SALARIO",
           "TIPO_C",
           "OBSERV",
           "TIPO_IDENT",
           "PUESTO",
           "APELLIDO1",
           "APELLIDO2"
      FROM NAF47_TNET.ARPLCCSS@GPOETNET;