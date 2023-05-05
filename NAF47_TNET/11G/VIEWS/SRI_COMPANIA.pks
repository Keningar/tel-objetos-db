CREATE  FORCE VIEW "NAF47_TNET"."SRI_COMPANIA" ("NO_CIA", "ANIO", "MES", "ATS") AS 
  SELECT NO_CIA,
           ANIO,
           MES,
           NAF47_TNET.MIG_LEE_CAMPOS_LOB.F_SRI_COMPANIA_ATS (NO_CIA)    AS ATS
      FROM NAF47_TNET.SRI_COMPANIA@GPOETNET;