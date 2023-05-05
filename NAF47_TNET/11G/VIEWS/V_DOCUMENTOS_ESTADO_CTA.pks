CREATE  FORCE VIEW "NAF47_TNET"."V_DOCUMENTOS_ESTADO_CTA" ("NO_CIA", "CENTRO", "GRUPO", "NO_CLIENTE", "SUB_CLIENTE", "TIPO_DOC", "NO_DOCU", "NO_FISICO", "FECHA", "FECHA_VENCE", "DEBITOS", "CREDITOS", "ESTADO", "DETALLE", "DESCRIPCION", "TSTAMP", "SALDO") AS 
  SELECT "NO_CIA",
           "CENTRO",
           "GRUPO",
           "NO_CLIENTE",
           "SUB_CLIENTE",
           "TIPO_DOC",
           "NO_DOCU",
           "NO_FISICO",
           "FECHA",
           "FECHA_VENCE",
           "DEBITOS",
           "CREDITOS",
           "ESTADO",
           "DETALLE",
           "DESCRIPCION",
           "TSTAMP",
           "SALDO"
      FROM NAF47_TNET.V_DOCUMENTOS_ESTADO_CTA@GPOETNET;