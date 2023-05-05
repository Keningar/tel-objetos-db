CREATE  FORCE VIEW "NAF47_TNET"."ARPLINS" ("NO_CIA", "NO_EMPLE", "ANO", "MES", "NACION", "TIPO_IDENT", "CEDULA", "NO_ASEGURADO", "NOMBRE", "APELLIDO1", "APELLIDO2", "PUESTO", "SALARIO", "DIAS_LAB", "OBSERV") AS 
  SELECT "NO_CIA",
           "NO_EMPLE",
           "ANO",
           "MES",
           "NACION",
           "TIPO_IDENT",
           "CEDULA",
           "NO_ASEGURADO",
           "NOMBRE",
           "APELLIDO1",
           "APELLIDO2",
           "PUESTO",
           "SALARIO",
           "DIAS_LAB",
           "OBSERV"
      FROM NAF47_TNET.ARPLINS@GPOETNET;