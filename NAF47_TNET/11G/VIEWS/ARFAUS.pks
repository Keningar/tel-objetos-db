
CREATE  FORCE VIEW "NAF47_TNET"."ARFAUS" ("NO_CIA", "USUARIO", "CENTRO", "CENTROF", "DIG_FECHA", "TIPO_PRECIO", "TIPO_DOC", "VARIAR_TD", "VARIAR_TP", "VARIAR_PR", "VARIAR_PD", "VARIAR_PP", "VARIAR_FE", "VARIAR_VE", "VARIAR_BO", "VARIAR_CO", "BODEGA", "VENDEDOR", "VARIAR_CENTROF", "FACT_SINO", "REG_DEVO") AS 
  SELECT "NO_CIA",
           "USUARIO",
           "CENTRO",
           "CENTROF",
           "DIG_FECHA",
           "TIPO_PRECIO",
           "TIPO_DOC",
           "VARIAR_TD",
           "VARIAR_TP",
           "VARIAR_PR",
           "VARIAR_PD",
           "VARIAR_PP",
           "VARIAR_FE",
           "VARIAR_VE",
           "VARIAR_BO",
           "VARIAR_CO",
           "BODEGA",
           "VENDEDOR",
           "VARIAR_CENTROF",
           "FACT_SINO",
           "REG_DEVO"
      FROM NAF47_TNET.ARFAUS@GPOETNET;