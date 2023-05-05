CREATE  FORCE VIEW "NAF47_TNET"."CG_NOMINA_HISTORICO" ("ANO", "MES", "AREA", "DEPTO", "NO_CIA", "COD_PLA", "NO_EMPLE", "NO_INGRE", "CANTIDAD", "MONTO", "TASA", "NO_OPERA", "SOLO_CIA", "SALDO", "INDICADOR", "OBSERVACION", "NOMBRE") AS 
  SELECT "ANO",
           "MES",
           "AREA",
           "DEPTO",
           "NO_CIA",
           "COD_PLA",
           "NO_EMPLE",
           "NO_INGRE",
           "CANTIDAD",
           "MONTO",
           "TASA",
           "NO_OPERA",
           "SOLO_CIA",
           "SALDO",
           "INDICADOR",
           "OBSERVACION",
           "NOMBRE"
      FROM NAF47_TNET.CG_NOMINA_HISTORICO@GPOETNET;