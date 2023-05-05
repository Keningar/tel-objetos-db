CREATE FORCE EDITIONABLE VIEW "DB_FINANCIERO"."VISTA_FACTURAS_FCH_EMISION" ("PUNTO_ID", "VALOR_TOTAL", "FE_EMISION") AS 
  select idfc.punto_id, idfc.VALOR_TOTAL, SUBSTR(idfc.FE_EMISION,0,10) as FE_EMISION
from
  info_documento_financiero_cab idfc ,
  Admi_Tipo_Documento_Financiero atdf
where idfc.tipo_documento_id = atdf.id_tipo_documento
and lower(atdf.codigo_tipo_documento) in ('fac','facp')
and lower(idfc.estado_impresion_fact) not in ('cerrado','pendiente' , 'anulado', 'rechazado', 'rechazada', 'inactivo','eliminado');
CREATE FORCE EDITIONABLE VIEW "DB_FINANCIERO"."VISTA_IVA_CTA_RESUMIDO_12" ("PUNTO_ID", "TOTAL_BIENES", "TOTAL_SERVICIOS", "TOTAL_IVA_SERVICIOS", "TOTAL_IVA_BIENES") AS 
  SELECT ESTADO_CUENTA.PUNTO_ID, 
           SUM(ESTADO_CUENTA.TOTAL_BIENES) TOTAL_BIENES, 
           SUM(ESTADO_CUENTA.TOTAL_SERVICIOS) TOTAL_SERVICIOS, 
           SUM(ESTADO_CUENTA.TOTAL_IVA_SERVICIOS) TOTAL_IVA_SERVICIOS, 
           SUM(ESTADO_CUENTA.TOTAL_IVA_BIENES) TOTAL_IVA_BIENES
    FROM(
            SELECT DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID,
                   round(DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL_SERVICIOS, 2) as TOTAL_SERVICIOS,
                   round(DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.IMPUESTOS_SERVICIOS, 2) as TOTAL_IVA_SERVICIOS,
                   round(DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL_BIENES, 2) as TOTAL_BIENES,
                   round(DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.IMPUESTOS_BIENES, 2) as TOTAL_IVA_BIENES
            FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB
            WHERE DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.estado_impresion_fact NOT IN ('Inactivo', 'Anulado', 'Anulada', 'Rechazada', 
                                                                                            'Rechazado', 'Pendiente', 'Aprobada', 'Eliminado',
                                                                                            'ErrorGasto', 'ErrorDescuento', 'ErrorDuplicidad') 
            AND TIPO_DOCUMENTO_ID NOT IN (6,8)
            AND FE_EMISION < TO_DATE('01-06-2016', 'dd-MM-yyyy')
        ) ESTADO_CUENTA
    GROUP BY ESTADO_CUENTA.PUNTO_ID;