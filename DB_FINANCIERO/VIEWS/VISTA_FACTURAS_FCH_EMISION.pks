CREATE   OR REPLACE VIEW "DB_FINANCIERO"."VISTA_FACTURAS_FCH_EMISION" ("PUNTO_ID", "VALOR_TOTAL", "FE_EMISION") AS 
  select idfc.punto_id, idfc.VALOR_TOTAL, SUBSTR(idfc.FE_EMISION,0,10) as FE_EMISION
from
  info_documento_financiero_cab idfc ,
  Admi_Tipo_Documento_Financiero atdf
where idfc.tipo_documento_id = atdf.id_tipo_documento
and lower(atdf.codigo_tipo_documento) in ('fac','facp')
and lower(idfc.estado_impresion_fact) not in ('cerrado','pendiente' , 'anulado', 'rechazado', 'rechazada', 'inactivo','eliminado');
