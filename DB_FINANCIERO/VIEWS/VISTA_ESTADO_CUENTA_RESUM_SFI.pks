CREATE FORCE EDITIONABLE VIEW "DB_FINANCIERO"."VISTA_ESTADO_CUENTA_RESUM_SFI" ("PUNTO_ID", "SALDO") AS 
  SELECT
ESTADO_CUENTA.PUNTO_ID, SUM(ESTADO_CUENTA.VALOR_TOTAL) SALDO
FROM
(SELECT IDFC.PUNTO_ID, ROUND(IDFC.valor_total,2) AS VALOR_TOTAL
 FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
 WHERE
 IDFC.ESTADO_IMPRESION_FACT NOT IN ('Inactivo', 'Anulado','Anulada',
                                    'Rechazada','Rechazado','Pendiente','Aprobada',
                                    'Eliminado','ErrorGasto','ErrorDescuento','ErrorDuplicidad') 
 AND IDFC.TIPO_DOCUMENTO_ID NOT IN (6,8)
 AND IDFC.ID_DOCUMENTO NOT IN (SELECT IDC.DOCUMENTO_ID
                               FROM DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC,
                                    DB_COMERCIAL.ADMI_CARACTERISTICA AC
                               WHERE 
                               IDC.DOCUMENTO_ID          = IDFC.ID_DOCUMENTO
                               AND IDC.CARACTERISTICA_ID = AC.ID_CARACTERISTICA
                               AND AC.DESCRIPCION_CARACTERISTICA IN ('POR_CONTRATO_FISICO','POR_CONTRATO_DIGITAL')
                               AND AC.ESTADO = 'Activo'
                               AND IDFC.ESTADO_IMPRESION_FACT = 'Activo'
                               ) 
UNION ALL
SELECT
  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.punto_id,
  round(DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.valor_total,2)*-1 as valor_total
FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB
WHERE DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.estado_impresion_fact
NOT IN ('Inactivo', 'Anulado','Anulada','Rechazada','Rechazado','Pendiente','Aprobada','Eliminado') 
AND TIPO_DOCUMENTO_ID in (6,8)
UNION ALL
SELECT
  DB_FINANCIERO.INFO_PAGO_CAB.punto_id,
  round(DB_FINANCIERO.INFO_PAGO_DET.valor_pago,2)*-1 as valor_pago
FROM DB_FINANCIERO.INFO_PAGO_CAB,
  DB_FINANCIERO.INFO_PAGO_DET
WHERE DB_FINANCIERO.INFO_PAGO_CAB.estado_pago NOT IN ('Inactivo', 'Anulado','Asignado')
AND DB_FINANCIERO.INFO_PAGO_CAB.id_pago = DB_FINANCIERO.INFO_PAGO_DET.pago_id
AND NOT EXISTS(SELECT anto.id_pago
               FROM DB_FINANCIERO.INFO_PAGO_CAB anto
               WHERE DB_FINANCIERO.INFO_PAGO_CAB.ANTICIPO_ID = anto.ID_PAGO 
               AND anto.ESTADO_PAGO = 'Cerrado'
               AND DB_FINANCIERO.INFO_PAGO_CAB.TIPO_DOCUMENTO_ID = 10
              )     
) ESTADO_CUENTA
GROUP BY ESTADO_CUENTA.PUNTO_ID;