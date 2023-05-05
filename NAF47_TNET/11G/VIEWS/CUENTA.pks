CREATE  FORCE VIEW "NAF47_TNET"."CUENTA" ("CUENTA", "DESCRI", "IND_MOV", "PERMISO_CON", "PERMISO_CHE", "PERMISO_CXP", "PERMISO_PLA", "PERMISO_AFIJO", "PERMISO_INV", "PERMISO_APROV", "PERMISO_FACT", "PERMISO_CXC", "PERMISO_CCH", "ACEPTA_CC", "USADO_EN", "COMPARTIDO", "NIVEL", "NATURALEZA") AS 
  SELECT "CUENTA",
           "DESCRI",
           "IND_MOV",
           "PERMISO_CON",
           "PERMISO_CHE",
           "PERMISO_CXP",
           "PERMISO_PLA",
           "PERMISO_AFIJO",
           "PERMISO_INV",
           "PERMISO_APROV",
           "PERMISO_FACT",
           "PERMISO_CXC",
           "PERMISO_CCH",
           "ACEPTA_CC",
           "USADO_EN",
           "COMPARTIDO",
           "NIVEL",
           "NATURALEZA"
      FROM NAF47_TNET.CUENTA@GPOETNET;