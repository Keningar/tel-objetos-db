CREATE  FORCE VIEW "NAF47_TNET"."ARCKPF" ("NO_CIA", "CENTRO_COSTO", "NO_CTA", "NO_PROVE", "BENEFICIARIO", "COM_1", "FECHA_INICIAL", "FECHA_ULT_CK", "IND_QUI_MENS", "FRECUENCIA", "PAGOS", "MONTO", "IND_ADJ_MES", "CTA_CONTRAPARTIDA", "GENERADOS") AS 
  SELECT "NO_CIA",
           "CENTRO_COSTO",
           "NO_CTA",
           "NO_PROVE",
           "BENEFICIARIO",
           "COM_1",
           "FECHA_INICIAL",
           "FECHA_ULT_CK",
           "IND_QUI_MENS",
           "FRECUENCIA",
           "PAGOS",
           "MONTO",
           "IND_ADJ_MES",
           "CTA_CONTRAPARTIDA",
           "GENERADOS"
      FROM NAF47_TNET.ARCKPF@GPOETNET;