CREATE  FORCE VIEW "NAF47_TNET"."V_FACTU_CONTA" ("NO_CIA", "NO_ASIENTO", "NO_CLIENTE", "NOMBRE", "TIPO_DOC", "DESCRIPCION", "NO_DOCU", "CODIGO", "DESCRI", "CENTRO_COSTO", "DESCRIP_CC", "DEBITO", "CREDITO", "GLOSA", "ORIGEN", "CENTROD", "DESC_CENTRO") AS 
  SELECT "NO_CIA",
           "NO_ASIENTO",
           "NO_CLIENTE",
           "NOMBRE",
           "TIPO_DOC",
           "DESCRIPCION",
           "NO_DOCU",
           "CODIGO",
           "DESCRI",
           "CENTRO_COSTO",
           "DESCRIP_CC",
           "DEBITO",
           "CREDITO",
           "GLOSA",
           "ORIGEN",
           "CENTROD",
           "DESC_CENTRO"
      FROM NAF47_TNET.V_FACTU_CONTA@GPOETNET;