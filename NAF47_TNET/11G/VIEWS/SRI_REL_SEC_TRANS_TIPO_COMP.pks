CREATE  FORCE VIEW "NAF47_TNET"."SRI_REL_SEC_TRANS_TIPO_COMP" ("CODIGO_SEC_TRANS", "CODIGO_TIPO_COMP") AS 
  SELECT "CODIGO_SEC_TRANS", "CODIGO_TIPO_COMP"
      FROM NAF47_TNET.SRI_REL_SEC_TRANS_TIPO_COMP@GPOETNET;