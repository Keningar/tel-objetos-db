CREATE  FORCE VIEW "NAF47_TNET"."ARCGIED" ("CODIGO", "FECHA", "VALOR", "MODIFICABLE") AS 
  SELECT "CODIGO",
           "FECHA",
           "VALOR",
           "MODIFICABLE"
      FROM NAF47_TNET.ARCGIED@GPOETNET;