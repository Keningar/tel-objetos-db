CREATE  FORCE VIEW "NAF47_TNET"."ARPLCARGA_EXCEL_AUMENTOS" ("NO_CIA", "NO_EMPLE", "SAL_BAS") AS 
  SELECT "NO_CIA", "NO_EMPLE", "SAL_BAS"
      FROM NAF47_TNET.ARPLCARGA_EXCEL_AUMENTOS@GPOETNET;