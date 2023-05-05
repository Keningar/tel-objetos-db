CREATE  FORCE VIEW "NAF47_TNET"."ARCGLHO" ("NO_CIA", "NO_DOCU", "NO_FISICO", "SERIE_FISICO", "ANO", "MES", "FECHA", "COD_INTERNO", "NOMBRE", "DETALLE", "MONTO_BRUTO", "PORC_RETEN", "MONTO_RETEN", "MONTO_NETO", "ORIGEN", "ID_TRIBUTARIO", "CODIGO_TERCERO") AS 
  SELECT "NO_CIA",
           "NO_DOCU",
           "NO_FISICO",
           "SERIE_FISICO",
           "ANO",
           "MES",
           "FECHA",
           "COD_INTERNO",
           "NOMBRE",
           "DETALLE",
           "MONTO_BRUTO",
           "PORC_RETEN",
           "MONTO_RETEN",
           "MONTO_NETO",
           "ORIGEN",
           "ID_TRIBUTARIO",
           "CODIGO_TERCERO"
      FROM NAF47_TNET.ARCGLHO@GPOETNET;