CREATE  FORCE VIEW "NAF47_TNET"."V_INGRESO_BODEGA_FACTURA" ("NO_CIA", "NO_PROVE", "RAZON_SOCIAL", "TIPO_DOC", "NO_DOCU", "FECHA", "TOTAL", "VALOR_FACTURADO", "SALDO", "ID_TIPO_TRANSACCION", "NO_ORDEN", "ESTADO", "ADJUDICADOR", "OBSERV") AS 
  SELECT "NO_CIA",
           "NO_PROVE",
           "RAZON_SOCIAL",
           "TIPO_DOC",
           "NO_DOCU",
           "FECHA",
           "TOTAL",
           "VALOR_FACTURADO",
           "SALDO",
           "ID_TIPO_TRANSACCION",
           "NO_ORDEN",
           "ESTADO",
           "ADJUDICADOR",
           "OBSERV"
      FROM NAF47_TNET.V_INGRESO_BODEGA_FACTURA@GPOETNET;