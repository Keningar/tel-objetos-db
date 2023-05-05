CREATE  FORCE VIEW "NAF47_TNET"."ARCPCTD" ("GRUPO", "NO_CIA", "TIPO_DOC", "CTA_PROVE", "CTA_DPP", "CTA_PROVE_DOL", "CTA_DPP_DOL", "CTA_ANTICIPO") AS 
  SELECT "GRUPO",
           "NO_CIA",
           "TIPO_DOC",
           "CTA_PROVE",
           "CTA_DPP",
           "CTA_PROVE_DOL",
           "CTA_DPP_DOL",
           "CTA_ANTICIPO"
      FROM NAF47_TNET.ARCPCTD@GPOETNET;