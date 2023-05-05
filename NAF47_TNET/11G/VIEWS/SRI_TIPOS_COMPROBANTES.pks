CREATE  FORCE VIEW "NAF47_TNET"."SRI_TIPOS_COMPROBANTES" ("CODIGO", "FECHA_VIGENCIA", "DESCRIPCION", "AUTORIZA_PROVE", "NO_OBJETO_IVA", "AUTORIZA_CLIENTE") AS 
  SELECT "CODIGO",
           "FECHA_VIGENCIA",
           "DESCRIPCION",
           "AUTORIZA_PROVE",
           "NO_OBJETO_IVA",
           "AUTORIZA_CLIENTE"
      FROM NAF47_TNET.SRI_TIPOS_COMPROBANTES@GPOETNET;