CREATE  FORCE VIEW "NAF47_TNET"."V_NOMINA_CONTA" ("NO_CIA", "NO_ASIENTO", "COD_PLA", "DESC_PLANILLA", "ANO", "MES", "NO_EMPLE", "CODIGO", "TIPO_REMU", "CUENTA", "DESC_CUENTA", "CENTRO_COSTO", "DESCRIP_CC", "DEBITO", "CREDITO", "GLOSA") AS 
  SELECT "NO_CIA",
           "NO_ASIENTO",
           "COD_PLA",
           "DESC_PLANILLA",
           "ANO",
           "MES",
           "NO_EMPLE",
           "CODIGO",
           "TIPO_REMU",
           "CUENTA",
           "DESC_CUENTA",
           "CENTRO_COSTO",
           "DESCRIP_CC",
           "DEBITO",
           "CREDITO",
           "GLOSA"
      FROM NAF47_TNET.V_NOMINA_CONTA@GPOETNET;