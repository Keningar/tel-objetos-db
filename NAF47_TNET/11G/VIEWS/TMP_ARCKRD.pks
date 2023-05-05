CREATE  FORCE VIEW "NAF47_TNET"."TMP_ARCKRD" ("NO_CIA", "TIPO_DOCU", "NO_SECUENCIA", "TIPO_REFE", "NO_REFE", "NO_PROVE", "MONTO", "BCO_PROVE", "CTA_BCO_PROVE", "MONEDA_REFE", "MONTO_REFE", "DESCUENTO_PP", "DESCUENTO_PP_REFE") AS 
  SELECT "NO_CIA",
           "TIPO_DOCU",
           "NO_SECUENCIA",
           "TIPO_REFE",
           "NO_REFE",
           "NO_PROVE",
           "MONTO",
           "BCO_PROVE",
           "CTA_BCO_PROVE",
           "MONEDA_REFE",
           "MONTO_REFE",
           "DESCUENTO_PP",
           "DESCUENTO_PP_REFE"
      FROM NAF47_TNET.TMP_ARCKRD@GPOETNET;