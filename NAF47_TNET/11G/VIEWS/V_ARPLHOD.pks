CREATE  FORCE VIEW "NAF47_TNET"."V_ARPLHOD" ("NO_CIA", "COD_PLA", "NO_EMPLE", "ANO", "MES", "DIAS_LAB", "VACACIONES", "ENFERMEDAD", "PERMISO", "FALTA_INJUSTIFICADA", "ENFERMEDAD_IESS", "MATERNIDAD", "DIAS_NO_LAB_REM", "DIAS_NO_LAB_NO_REM", "SUELDO_NOM") AS 
  SELECT "NO_CIA",
           "COD_PLA",
           "NO_EMPLE",
           "ANO",
           "MES",
           "DIAS_LAB",
           "VACACIONES",
           "ENFERMEDAD",
           "PERMISO",
           "FALTA_INJUSTIFICADA",
           "ENFERMEDAD_IESS",
           "MATERNIDAD",
           "DIAS_NO_LAB_REM",
           "DIAS_NO_LAB_NO_REM",
           "SUELDO_NOM"
      FROM NAF47_TNET.V_ARPLHOD@GPOETNET;