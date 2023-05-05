CREATE  FORCE VIEW "NAF47_TNET"."ARPLGRR" ("NO_CIA", "NO_REP", "FECHA_GEN", "COD_PLA", "GRUPO", "SUB_GRUPO", "TIPO_REG", "NO_EMPLE", "LINEA", "M1", "M2", "M3", "M4", "M5", "M6", "M7", "M8", "M9", "M10", "M11", "M12", "M13", "M14", "M15") AS 
  SELECT "NO_CIA",
           "NO_REP",
           "FECHA_GEN",
           "COD_PLA",
           "GRUPO",
           "SUB_GRUPO",
           "TIPO_REG",
           "NO_EMPLE",
           "LINEA",
           "M1",
           "M2",
           "M3",
           "M4",
           "M5",
           "M6",
           "M7",
           "M8",
           "M9",
           "M10",
           "M11",
           "M12",
           "M13",
           "M14",
           "M15"
      FROM NAF47_TNET.ARPLGRR@GPOETNET;