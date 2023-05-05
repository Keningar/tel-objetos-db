CREATE FORCE EDITIONABLE VIEW "DB_FINANCIERO"."VISTA_ESTADO_CTA_RESUMIDO_14" ("PUNTO_ID", "SALDO") AS 
  SELECT
ESTADO_CUENTA.PUNTO_ID, SUM(ESTADO_CUENTA.VALOR_TOTAL) SALDO
FROM
(SELECT DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.punto_id,
round(DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.valor_total,2) as valor_total
FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB
WHERE DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.estado_impresion_fact 
NOT IN ('Inactivo', 'Anulado','Anulada','Rechazada','Rechazado','Pendiente','Aprobada','Eliminado','ErrorGasto','ErrorDescuento','ErrorDuplicidad') 
AND TIPO_DOCUMENTO_ID not in (6,8)
AND FE_EMISION >= TO_DATE('01-06-2016', 'dd-MM-yyyy')
UNION ALL
SELECT

DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.punto_id,
round(DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.valor_total,2)*-1 as valor_total
FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB
WHERE DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.estado_impresion_fact
NOT IN ('Inactivo', 'Anulado','Anulada','Rechazada','Rechazado','Pendiente','Aprobada','Eliminado') AND TIPO_DOCUMENTO_ID in (6,8)
AND REFERENCIA_DOCUMENTO_ID IN (
                                    SELECT idfc.ID_DOCUMENTO
                                    FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB idfc
                                    WHERE idfc.estado_impresion_fact 
                                    NOT IN ('Inactivo', 'Anulado','Anulada','Rechazada','Rechazado','Pendiente','Aprobada','Eliminado','ErrorGasto',
                                            'ErrorDescuento','ErrorDuplicidad') 
                                    AND idfc.TIPO_DOCUMENTO_ID not in (6,8)
                                    AND idfc.FE_EMISION >= TO_DATE('01-06-2016', 'dd-MM-yyyy')
                               )
UNION ALL
SELECT
ipc.punto_id,
round(ipd.valor_pago,2)*-1 as valor_pago
FROM DB_FINANCIERO.INFO_PAGO_CAB ipc,
DB_FINANCIERO.INFO_PAGO_DET ipd
WHERE ipc.estado_pago NOT IN ('Inactivo', 'Anulado','Asignado')
AND ipc.id_pago = ipd.pago_id
AND( 
      ipd.REFERENCIA_ID IN (
                              SELECT idfc2.ID_DOCUMENTO
                              FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB idfc2
                              WHERE idfc2.estado_impresion_fact 
                              NOT IN ('Inactivo', 'Anulado','Anulada','Rechazada','Rechazado','Pendiente','Aprobada','Eliminado','ErrorGasto',
                                      'ErrorDescuento','ErrorDuplicidad') 
                              AND idfc2.TIPO_DOCUMENTO_ID not in (6,8)
                              AND idfc2.FE_EMISION >= TO_DATE('01-06-2016', 'dd-MM-yyyy')
                          )
      OR ipd.ID_PAGO_DET IN (
                                SELECT idfd2.PAGO_DET_ID
                                FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB idfc2
                                JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET idfd2
                                ON idfc2.ID_DOCUMENTO = idfd2.DOCUMENTO_ID
                                WHERE idfc2.estado_impresion_fact 
                                NOT IN ('Inactivo', 'Anulado','Anulada','Rechazada','Rechazado','Pendiente','Aprobada','Eliminado','ErrorGasto',
                                        'ErrorDescuento','ErrorDuplicidad') 
                                AND idfc2.TIPO_DOCUMENTO_ID in (12, 9)
                                AND idfc2.FE_EMISION >= TO_DATE('01-06-2016', 'dd-MM-yyyy')
                            )
                    OR ipc.ID_PAGO IN (
                                          SELECT ipc2.ID_PAGO
                                          FROM DB_FINANCIERO.INFO_PAGO_CAB ipc2
                                          WHERE ipc2.ESTADO_PAGO = 'Pendiente' 
                                            AND ipc2.TIPO_DOCUMENTO_ID IN (3, 4, 10)
                                            AND ipc2.PUNTO_ID IS NOT NULL
                                      )
  )
) ESTADO_CUENTA
GROUP BY ESTADO_CUENTA.PUNTO_ID;