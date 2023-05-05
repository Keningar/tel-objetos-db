CREATE  FORCE VIEW "NAF47_TNET"."V_CONFIGURACION_FORM_FACT" ("TIPO", "TIPO_MOV", "DESCRIPCION", "IND_FAC_DEV", "MAX_LINEA", "PEDIDO", "TIPO_DOC_CXC", "TIPO_DOC_INVE", "FORMULARIO", "DESC_FORMULARIO", "SIGUIENTE") AS 
  SELECT "TIPO",
           "TIPO_MOV",
           "DESCRIPCION",
           "IND_FAC_DEV",
           "MAX_LINEA",
           "PEDIDO",
           "TIPO_DOC_CXC",
           "TIPO_DOC_INVE",
           "FORMULARIO",
           "DESC_FORMULARIO",
           "SIGUIENTE"
      FROM NAF47_TNET.V_CONFIGURACION_FORM_FACT@GPOETNET;