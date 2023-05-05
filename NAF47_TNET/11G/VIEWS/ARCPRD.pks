CREATE  FORCE VIEW "NAF47_TNET"."ARCPRD" ("NO_CIA", "TIPO_DOC", "NO_DOCU", "TIPO_REFE", "NO_REFE", "MONTO", "MONTO_REFE", "MONEDA_REFE", "DESCUENTO_PP", "FEC_APLIC", "ANO", "MES", "IND_PROCESADO", "NO_PROVE", "DIF_CAMBIARIO", "PROCEDENCIA", "ID_FORMA_PAGO") AS 
  SELECT "NO_CIA",
           "TIPO_DOC",
           "NO_DOCU",
           "TIPO_REFE",
           "NO_REFE",
           "MONTO",
           "MONTO_REFE",
           "MONEDA_REFE",
           "DESCUENTO_PP",
           "FEC_APLIC",
           "ANO",
           "MES",
           "IND_PROCESADO",
           "NO_PROVE",
           "DIF_CAMBIARIO",
           "PROCEDENCIA",
           "ID_FORMA_PAGO"
      FROM NAF47_TNET.ARCPRD@GPOETNET;