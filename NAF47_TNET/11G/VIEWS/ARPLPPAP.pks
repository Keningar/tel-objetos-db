
CREATE  FORCE VIEW "NAF47_TNET"."ARPLPPAP" ("NO_CIA", "NO_EMPLE", "TIPO_A", "NO_ACCION", "COD_PLA", "DIAS_CAL", "DIAS_FERIADOS", "DIAS", "HORAS", "IND_REG") AS 
  SELECT "NO_CIA",
           "NO_EMPLE",
           "TIPO_A",
           "NO_ACCION",
           "COD_PLA",
           "DIAS_CAL",
           "DIAS_FERIADOS",
           "DIAS",
           "HORAS",
           "IND_REG"
      FROM NAF47_TNET.ARPLPPAP@GPOETNET;