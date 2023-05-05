CREATE FORCE EDITIONABLE VIEW "DB_FINANCIERO"."VISTA_ESTADO_CUENTA_RESUMIDO_2" ("PUNTO_ID", "SALDO") AS 
  SELECT
ESTADO_CUENTA.PUNTO_ID, SUM(ESTADO_CUENTA.VALOR_TOTAL) SALDO
FROM
(SELECT

DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.punto_id,
DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.valor_total
FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB
WHERE DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.estado_impresion_fact
NOT IN ('Inactivo', 'Anulado','Anulada','Rechazada','Rechazado','Pendiente','Aprobada','Eliminado') AND TIPO_DOCUMENTO_ID<>6
UNION ALL
SELECT

DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.punto_id,
DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.valor_total*-1
FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB
WHERE DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.estado_impresion_fact
NOT IN ('Inactivo', 'Anulado','Anulada','Rechazada','Rechazado','Pendiente','Aprobada','Eliminado') AND TIPO_DOCUMENTO_ID=6
AND DB_FINANCIERO.info_documento_financiero_cab.referencia_documento_id IN
(SELECT

DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.id_documento
FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB
WHERE DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.estado_impresion_fact
NOT IN ('Inactivo', 'Anulado','Anulada','Rechazada','Rechazado','Pendiente','Aprobada','Eliminado') AND TIPO_DOCUMENTO_ID<>6
--AND to_char(DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.FE_EMISION,'YYYY/MM/DD')<=CONCAT(to_char(sysdate, 'YYYY/MM'),'/01')
)

UNION ALL
SELECT
DB_FINANCIERO.INFO_PAGO_CAB.punto_id,
DB_FINANCIERO.INFO_PAGO_DET.valor_pago*-1
FROM DB_FINANCIERO.INFO_PAGO_CAB,
DB_FINANCIERO.INFO_PAGO_DET
WHERE DB_FINANCIERO.INFO_PAGO_CAB.estado_pago NOT IN ('Inactivo', 'Anulado','Asignado')
AND DB_FINANCIERO.INFO_PAGO_CAB.id_pago = DB_FINANCIERO.INFO_PAGO_DET.pago_id
) ESTADO_CUENTA
GROUP BY ESTADO_CUENTA.PUNTO_ID;