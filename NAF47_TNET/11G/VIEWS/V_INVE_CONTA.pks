CREATE  FORCE VIEW "NAF47_TNET"."V_INVE_CONTA" ("NO_CIA", "NO_ASIENTO", "TIPO_DOC", "DESC_TDOC", "NO_DOCU", "CUENTA", "DESC_CUENTA", "CENTRO_COSTO", "DESCRIP_CC", "DEBITO", "CREDITO", "GLOSA", "ORIGEN", "CENTRO", "DESC_CENTRO") AS 
  SELECT "NO_CIA",
           "NO_ASIENTO",
           "TIPO_DOC",
           "DESC_TDOC",
           "NO_DOCU",
           "CUENTA",
           "DESC_CUENTA",
           "CENTRO_COSTO",
           "DESCRIP_CC",
           "DEBITO",
           "CREDITO",
           "GLOSA",
           "ORIGEN",
           "CENTRO",
           "DESC_CENTRO"
      FROM NAF47_TNET.V_INVE_CONTA@GPOETNET;