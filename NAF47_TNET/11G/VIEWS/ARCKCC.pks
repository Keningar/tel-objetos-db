

CREATE  FORCE VIEW "NAF47_TNET"."ARCKCC" ("NO_CIA", "NO_CTA", "PROCE", "TIPO_DOC", "NO_DOCU", "PROCEDENCIA_R", "TIPO_DOC_R", "NO_DOCU_R", "ANO", "MES") AS 
  SELECT "NO_CIA",
           "NO_CTA",
           "PROCE",
           "TIPO_DOC",
           "NO_DOCU",
           "PROCEDENCIA_R",
           "TIPO_DOC_R",
           "NO_DOCU_R",
           "ANO",
           "MES"
      FROM NAF47_TNET.ARCKCC@GPOETNET;