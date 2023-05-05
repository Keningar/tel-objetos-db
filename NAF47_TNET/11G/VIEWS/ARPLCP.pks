CREATE  FORCE VIEW "NAF47_TNET"."ARPLCP" ("NO_CIA", "CODPLA", "TIPLA", "SALARIAL", "DESCRI", "ANO_PROCE", "MES_PROCE", "NO_PLANI", "F_DESDE", "F_HASTA", "F_TARJ_DESDE", "F_TARJ_HASTA", "F_CALCULO", "TIPO_EMP", "CUENTA_PXP", "ESTADO", "IND_CK_ACT", "REDONDEO", "TC_CALCULO", "NO_ASIENTO", "DIAS_HABILES", "ULTIMA_PLANILLA", "IND_ING_MODIF", "CUENTA_MOD_CK", "CENTRO_COSTO") AS 
  SELECT "NO_CIA",
           "CODPLA",
           "TIPLA",
           "SALARIAL",
           "DESCRI",
           "ANO_PROCE",
           "MES_PROCE",
           "NO_PLANI",
           "F_DESDE",
           "F_HASTA",
           "F_TARJ_DESDE",
           "F_TARJ_HASTA",
           "F_CALCULO",
           "TIPO_EMP",
           "CUENTA_PXP",
           "ESTADO",
           "IND_CK_ACT",
           "REDONDEO",
           "TC_CALCULO",
           "NO_ASIENTO",
           "DIAS_HABILES",
           "ULTIMA_PLANILLA",
           "IND_ING_MODIF",
           "CUENTA_MOD_CK",
           "CENTRO_COSTO"
      FROM NAF47_TNET.ARPLCP@GPOETNET;