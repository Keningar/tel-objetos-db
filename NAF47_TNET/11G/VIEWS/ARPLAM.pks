CREATE  FORCE VIEW "NAF47_TNET"."ARPLAM" ("NO_CIA", "NO_EMPLE", "NO_DEDU", "NO_OPERA", "ANO", "MES", "PERIODO", "TASA", "FECHA", "MONEDA", "SALDO_ANT", "INTERESES", "ABONO", "AMORTIZA", "AUMENTO") AS 
  SELECT "NO_CIA",
           "NO_EMPLE",
           "NO_DEDU",
           "NO_OPERA",
           "ANO",
           "MES",
           "PERIODO",
           "TASA",
           "FECHA",
           "MONEDA",
           "SALDO_ANT",
           "INTERESES",
           "ABONO",
           "AMORTIZA",
           "AUMENTO"
      FROM NAF47_TNET.ARPLAM@GPOETNET;