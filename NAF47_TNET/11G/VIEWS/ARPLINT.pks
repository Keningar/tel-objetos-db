CREATE  FORCE VIEW "NAF47_TNET"."ARPLINT" ("NO_CIA", "COD_PLA", "NO_EMPLE", "NO_INGRE", "UNID_MEDIDA", "CANTIDAD", "MONTO_UNIDAD", "SALDO", "IND_GEN_AUTO", "FECHA", "IND_PROCESADO", "IND_FALTA") AS 
  SELECT "NO_CIA",
           "COD_PLA",
           "NO_EMPLE",
           "NO_INGRE",
           "UNID_MEDIDA",
           "CANTIDAD",
           "MONTO_UNIDAD",
           "SALDO",
           "IND_GEN_AUTO",
           "FECHA",
           "IND_PROCESADO",
           "IND_FALTA"
      FROM NAF47_TNET.ARPLINT@GPOETNET;