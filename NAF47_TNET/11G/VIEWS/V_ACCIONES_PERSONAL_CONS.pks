CREATE  FORCE VIEW "NAF47_TNET"."V_ACCIONES_PERSONAL_CONS" ("NO_CIA", "ANO", "MES", "NO_EMPLE", "NOMBRE_EMPLEADO", "DIAS", "COD_PLA", "DESCRIPCION", "REMUNERADO") AS 
  SELECT "NO_CIA",
           "ANO",
           "MES",
           "NO_EMPLE",
           "NOMBRE_EMPLEADO",
           "DIAS",
           "COD_PLA",
           "DESCRIPCION",
           "REMUNERADO"
      FROM NAF47_TNET.V_ACCIONES_PERSONAL_CONS@GPOETNET;