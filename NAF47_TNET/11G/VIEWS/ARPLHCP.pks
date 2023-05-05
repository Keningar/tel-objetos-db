CREATE  FORCE VIEW "NAF47_TNET"."ARPLHCP" ("NO_CIA", "COD_PLA", "TIPLA", "ANO_PROCE", "MES_PROCE", "NO_PLANI", "DESCRI", "F_DESDE", "F_HASTA", "F_TARJ_DESDE", "F_TARJ_HASTA", "F_CALCULO", "TIPO_EMP", "TC_CALCULO", "F_SISTEMA") AS 
  SELECT "NO_CIA",
           "COD_PLA",
           "TIPLA",
           "ANO_PROCE",
           "MES_PROCE",
           "NO_PLANI",
           "DESCRI",
           "F_DESDE",
           "F_HASTA",
           "F_TARJ_DESDE",
           "F_TARJ_HASTA",
           "F_CALCULO",
           "TIPO_EMP",
           "TC_CALCULO",
           "F_SISTEMA"
      FROM NAF47_TNET.ARPLHCP@GPOETNET;