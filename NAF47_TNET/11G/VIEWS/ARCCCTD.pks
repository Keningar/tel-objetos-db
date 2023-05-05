
CREATE  FORCE VIEW "NAF47_TNET"."ARCCCTD" ("GRUPO", "NO_CIA", "TIPO_DOC", "CTA_CLIENTE", "CTA_CONTRAPARTIDA", "CTA_DPP", "CTA_CLIENTE_DOL", "CTA_CONTRAPARTIDA_DOL", "CTA_DPP_DOL", "CTA_ANTICIPO") AS 
  SELECT "GRUPO",
           "NO_CIA",
           "TIPO_DOC",
           "CTA_CLIENTE",
           "CTA_CONTRAPARTIDA",
           "CTA_DPP",
           "CTA_CLIENTE_DOL",
           "CTA_CONTRAPARTIDA_DOL",
           "CTA_DPP_DOL",
           "CTA_ANTICIPO"
      FROM NAF47_TNET.ARCCCTD@GPOETNET;