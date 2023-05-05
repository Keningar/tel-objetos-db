CREATE  FORCE VIEW "NAF47_TNET"."ARPLTE" ("NO_CIA", "TIPO_EMP", "DESCRIP", "N_HORAS", "DIAS_TRAB", "HORXMES", "CLASE_EMP", "JORNADA", "ES_TRABAJADOR") AS 
  SELECT "NO_CIA",
           "TIPO_EMP",
           "DESCRIP",
           "N_HORAS",
           "DIAS_TRAB",
           "HORXMES",
           "CLASE_EMP",
           "JORNADA",
           "ES_TRABAJADOR"
      FROM NAF47_TNET.ARPLTE@GPOETNET;