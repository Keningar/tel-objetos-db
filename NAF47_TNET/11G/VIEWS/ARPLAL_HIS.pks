
CREATE  FORCE VIEW "NAF47_TNET"."ARPLAL_HIS" ("NO_CIA", "COD_PLA", "ANO", "MES", "NO_ASIENTO_TMP", "NO_LINEA", "DESCRI", "CUENTA", "NO_DOCU", "MONTO", "TIPO", "CENTRO_COSTO", "IND_CON", "NO_ASIENTO", "IND_GENERADO", "RETROACTIVO", "NO_EMPLE", "CODIGO", "TIPO_REMU") AS 
  SELECT "NO_CIA",
           "COD_PLA",
           "ANO",
           "MES",
           "NO_ASIENTO_TMP",
           "NO_LINEA",
           "DESCRI",
           "CUENTA",
           "NO_DOCU",
           "MONTO",
           "TIPO",
           "CENTRO_COSTO",
           "IND_CON",
           "NO_ASIENTO",
           "IND_GENERADO",
           "RETROACTIVO",
           "NO_EMPLE",
           "CODIGO",
           "TIPO_REMU"
      FROM NAF47_TNET.ARPLAL_HIS@GPOETNET;