CREATE  FORCE VIEW "NAF47_TNET"."ARINRE" ("NO_CIA", "CENTRO", "NO_DOCU", "ESTADO", "FECHA", "NO_FISICO", "SERIE_FISICO", "NO_PROVE", "TIPO_DOC_REFE", "NO_DOCU_REFE", "NO_FISICO_REFE", "SERIE_FISICO_REFE", "OBSERV1") AS 
  SELECT "NO_CIA",
           "CENTRO",
           "NO_DOCU",
           "ESTADO",
           "FECHA",
           "NO_FISICO",
           "SERIE_FISICO",
           "NO_PROVE",
           "TIPO_DOC_REFE",
           "NO_DOCU_REFE",
           "NO_FISICO_REFE",
           "SERIE_FISICO_REFE",
           "OBSERV1"
      FROM NAF47_TNET.ARINRE@GPOETNET;