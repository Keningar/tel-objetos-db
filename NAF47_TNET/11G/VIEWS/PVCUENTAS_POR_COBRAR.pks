CREATE  FORCE VIEW "NAF47_TNET"."PVCUENTAS_POR_COBRAR" ("NO_CIA", "CENTRO", "TIPO_DOC", "PERIODO", "RUTA", "NO_DOCU", "GRUPO", "NO_CLIENTE", "FECHA", "FECHA_VENCE", "NO_AGENTE", "M_ORIGINAL", "SALDO", "DESCUENTO", "TOTAL_REF", "ESTADO", "NO_FISICO", "SERIE_FISICO", "MONEDA", "TSTAMP", "IND_PROCESADO_OC", "TIPO_MOV", "DESCRIPCION", "USUARIO", "SUBCLIENTE", "NO_DOCU_REFE") AS 
  SELECT "NO_CIA",
           "CENTRO",
           "TIPO_DOC",
           "PERIODO",
           "RUTA",
           "NO_DOCU",
           "GRUPO",
           "NO_CLIENTE",
           "FECHA",
           "FECHA_VENCE",
           "NO_AGENTE",
           "M_ORIGINAL",
           "SALDO",
           "DESCUENTO",
           "TOTAL_REF",
           "ESTADO",
           "NO_FISICO",
           "SERIE_FISICO",
           "MONEDA",
           "TSTAMP",
           "IND_PROCESADO_OC",
           "TIPO_MOV",
           "DESCRIPCION",
           "USUARIO",
           "SUBCLIENTE",
           "NO_DOCU_REFE"
      FROM NAF47_TNET.PVCUENTAS_POR_COBRAR@GPOETNET;