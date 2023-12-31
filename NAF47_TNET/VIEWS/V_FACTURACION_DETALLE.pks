CREATE    OR REPLACE VIEW "NAF47_TNET"."V_FACTURACION_DETALLE" ("ID_ITEM_DETALLE", "DOCUMENTO_ID", "EMPRESA_ID", "OFICINA_ID", "PRODUCTO_ID", "CODIGO_PRODUCTO", "DESCRIPCION_PRODUCTO") AS 
  SELECT IDDP.ID_ITEM_DETALLE,
         IDDP.DOCUMENTO_ID,
         IDDP.EMPRESA_ID,
         IDDP.OFICINA_ID,
         IDDP.PRODUCTO_ID,
         AP.CODIGO_PRODUCTO,
         AP.DESCRIPCION_PRODUCTO
  FROM DB_COMERCIAL.ADMI_PRODUCTO AP,
       DB_FINANCIERO.INFO_DOCUMENTO_DETALLE_PRODUCT IDDP
  WHERE IDDP.PRODUCTO_ID = AP.ID_PRODUCTO;