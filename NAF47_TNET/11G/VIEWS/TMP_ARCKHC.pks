CREATE  FORCE VIEW "NAF47_TNET"."TMP_ARCKHC" ("NO_CIA", "NO_CTA", "ANO", "MES", "CHE_MES", "CHE_ANULMESANT", "DEP_MES", "DEB_MES", "CRE_MES", "SALDO_FIN_C", "SALDO_FIN_B", "SALDO_CONCILIADO") AS 
  SELECT "NO_CIA",
           "NO_CTA",
           "ANO",
           "MES",
           "CHE_MES",
           "CHE_ANULMESANT",
           "DEP_MES",
           "DEB_MES",
           "CRE_MES",
           "SALDO_FIN_C",
           "SALDO_FIN_B",
           "SALDO_CONCILIADO"
      FROM NAF47_TNET.TMP_ARCKHC@GPOETNET;