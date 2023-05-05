CREATE  FORCE VIEW "NAF47_TNET"."ARAFMA_PARTES" ("NO_CIA", "NO_ACTI", "NO_PARTE", "DESCRI", "SERIE", "MARCA", "MODELO", "NO_FISICO", "FECHA_FAB", "FECHA_INST", "FREC_MANTE", "CONDICION", "TECNOLOGIA", "COD_INT_ACTIVO") AS 
  SELECT "NO_CIA",
           "NO_ACTI",
           "NO_PARTE",
           "DESCRI",
           "SERIE",
           "MARCA",
           "MODELO",
           "NO_FISICO",
           "FECHA_FAB",
           "FECHA_INST",
           "FREC_MANTE",
           "CONDICION",
           "TECNOLOGIA",
           "COD_INT_ACTIVO"
      FROM NAF47_TNET.ARAFMA_PARTES@GPOETNET;