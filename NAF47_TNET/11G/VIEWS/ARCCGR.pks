
CREATE  FORCE VIEW "NAF47_TNET"."ARCCGR" ("NO_CIA", "GRUPO", "DESCRIPCION", "CTA_CLIENTE", "CTA_DPP", "CTA_CLIENTE_DOL", "CTA_DPP_DOL", "CTA_ANTICIPO", "CENTRO_REFERENCIA", "IND_PRINCIPAL", "GRUPO_MUESTRARIO", "CTA_DIFERENCIA", "MARGEN_CIA_RELACIONADO", "IND_MARGEN_CIA_RELACIONADO") AS 
  SELECT "NO_CIA",
           "GRUPO",
           "DESCRIPCION",
           "CTA_CLIENTE",
           "CTA_DPP",
           "CTA_CLIENTE_DOL",
           "CTA_DPP_DOL",
           "CTA_ANTICIPO",
           "CENTRO_REFERENCIA",
           "IND_PRINCIPAL",
           "GRUPO_MUESTRARIO",
           "CTA_DIFERENCIA",
           "MARGEN_CIA_RELACIONADO",
           "IND_MARGEN_CIA_RELACIONADO"
      FROM NAF47_TNET.ARCCGR@GPOETNET;