CREATE  FORCE VIEW "NAF47_TNET"."SRI_TIPOS_PAGO" ("CODIGO", "DESCRIPCION") AS 
  SELECT "CODIGO", "DESCRIPCION" FROM NAF47_TNET.SRI_TIPOS_PAGO@GPOETNET;