CREATE  OR REPLACE VIEW "NAF47_TNET"."V_FACTURACION_DETALLE" ("ID_ITEM_DETALLE", "DOCUMENTO_ID", "EMPRESA_ID", "OFICINA_ID", "PRODUCTO_ID", "CODIGO_PRODUCTO", "DESCRIPCION_PRODUCTO") AS 
  SELECT "ID_ITEM_DETALLE",
           "DOCUMENTO_ID",
           "EMPRESA_ID",
           "OFICINA_ID",
           "PRODUCTO_ID",
           "CODIGO_PRODUCTO",
           "DESCRIPCION_PRODUCTO"
      FROM NAF47_TNET.V_FACTURACION_DETALLE@GPOETNET;