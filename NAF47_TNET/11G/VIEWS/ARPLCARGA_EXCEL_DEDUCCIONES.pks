CREATE  FORCE VIEW "NAF47_TNET"."ARPLCARGA_EXCEL_DEDUCCIONES" ("NO_CIA", "COD_PLA", "NO_EMPLE", "NO_DEDU", "MONTO", "USUARIO") AS 
  SELECT "NO_CIA",
           "COD_PLA",
           "NO_EMPLE",
           "NO_DEDU",
           "MONTO",
           "USUARIO"
      FROM NAF47_TNET.ARPLCARGA_EXCEL_DEDUCCIONES@GPOETNET;