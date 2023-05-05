CREATE  FORCE VIEW "NAF47_TNET"."ARCCAUX1" ("NO_CIA", "CENTRO", "TIPO_DOC", "PERIODO", "RUTA", "NO_DOCU", "GRUPO", "NO_CLIENTE", "SALDO", "FECHA", "FECHA_VENCE", "MONEDA", "SUB_CLIENTE") AS 
  SELECT "NO_CIA",
           "CENTRO",
           "TIPO_DOC",
           "PERIODO",
           "RUTA",
           "NO_DOCU",
           "GRUPO",
           "NO_CLIENTE",
           "SALDO",
           "FECHA",
           "FECHA_VENCE",
           "MONEDA",
           "SUB_CLIENTE"
      FROM NAF47_TNET.ARCCAUX1@GPOETNET;