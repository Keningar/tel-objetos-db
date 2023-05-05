CREATE  FORCE VIEW "NAF47_TNET"."TEMP_RECOSTEO" ("NO_CIA", "NO_EMBARQUE", "NO_ARTI", "PARTIDA", "CANT_PED", "CANT_REC", "FOB", "POR_VALOREM", "POR_FODINFA", "PRORRATEO", "PRO_FLETE", "PRO_SEGURO", "CIF_ARTICULO", "AD_VAL_ARTI", "FODINFA_ARTI", "OTROS_ARTI", "GASTO_ARTI", "FACTOR_2") AS 
  SELECT "NO_CIA",
           "NO_EMBARQUE",
           "NO_ARTI",
           "PARTIDA",
           "CANT_PED",
           "CANT_REC",
           "FOB",
           "POR_VALOREM",
           "POR_FODINFA",
           "PRORRATEO",
           "PRO_FLETE",
           "PRO_SEGURO",
           "CIF_ARTICULO",
           "AD_VAL_ARTI",
           "FODINFA_ARTI",
           "OTROS_ARTI",
           "GASTO_ARTI",
           "FACTOR_2"
      FROM NAF47_TNET.TEMP_RECOSTEO@GPOETNET;