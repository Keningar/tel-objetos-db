CREATE  FORCE VIEW "NAF47_TNET"."INCOTERMS" ("CODIGO", "SIGNIFICADO", "LUGAR", "ETIQUETA") AS 
  SELECT "CODIGO",
           "SIGNIFICADO",
           "LUGAR",
           "ETIQUETA"
      FROM NAF47_TNET.INCOTERMS@GPOETNET;