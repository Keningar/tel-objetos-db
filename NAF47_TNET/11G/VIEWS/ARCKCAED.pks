
CREATE  FORCE VIEW "NAF47_TNET"."ARCKCAED" ("NO_CIA", "NO_CTA", "PROCE", "TIPO_DOC", "NO_DOCU", "PROCEDENCIA_R", "TIPO_DOC_R", "NO_DOCU_R") AS 
  SELECT "NO_CIA",
           "NO_CTA",
           "PROCE",
           "TIPO_DOC",
           "NO_DOCU",
           "PROCEDENCIA_R",
           "TIPO_DOC_R",
           "NO_DOCU_R"
      FROM NAF47_TNET.ARCKCAED@GPOETNET;