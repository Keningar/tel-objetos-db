CREATE  FORCE VIEW "NAF47_TNET"."TMP_ARCKRA" ("NO_CIA", "NO_CTA", "PROCEDENCIA", "TIPO_DOC", "NO_DOCU", "TIPO_REFE", "NO_REFE", "MONTO", "ANO_AJUSTE", "MES_AJUSTE", "MONTO_AJUSTE") AS 
  SELECT "NO_CIA",
           "NO_CTA",
           "PROCEDENCIA",
           "TIPO_DOC",
           "NO_DOCU",
           "TIPO_REFE",
           "NO_REFE",
           "MONTO",
           "ANO_AJUSTE",
           "MES_AJUSTE",
           "MONTO_AJUSTE"
      FROM NAF47_TNET.TMP_ARCKRA@GPOETNET;