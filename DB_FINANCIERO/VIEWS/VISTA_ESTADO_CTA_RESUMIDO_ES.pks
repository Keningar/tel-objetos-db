CREATE FORCE EDITIONABLE VIEW "DB_FINANCIERO"."VISTA_ESTADO_CTA_RESUMIDO_ES" ("PUNTO_ID", "SALDO") AS 
  SELECT ESTADO_CUENTA.PUNTO_ID, 
  SUM(ESTADO_CUENTA.VALOR_TOTAL) SALDO
FROM (SELECT DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID,
        ROUND(DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL,2) AS VALOR_TOTAL
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB
      WHERE DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT NOT IN ('Inactivo', 'Anulado','Anulada',
                                                                                      'Rechazada','Rechazado','Pendiente',
                                                                                      'Aprobada','Eliminado','ErrorGasto',
                                                                                      'ErrorDescuento','ErrorDuplicidad') 
      AND TIPO_DOCUMENTO_ID                                                   NOT IN (6,8)
      AND NOT EXISTS (SELECT  IDC.CARACTERISTICA_ID 
                      FROM DB_COMERCIAL.ADMI_CARACTERISTICA DBAC,
                        DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC
                      WHERE DBAC.DESCRIPCION_CARACTERISTICA = 'PROCESO_DIFERIDO'
                      AND IDC.DOCUMENTO_ID                  = DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO
                      AND IDC.CARACTERISTICA_ID             = DBAC.ID_CARACTERISTICA
                      AND IDC.VALOR                         = 'S')
      UNION ALL
      SELECT DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID,
        ROUND(DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL,2)*-1 AS VALOR_TOTAL
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB
      WHERE DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT NOT IN ('Inactivo', 'Anulado','Anulada',
                                                                                      'Rechazada','Rechazado','Pendiente',
                                                                                      'Aprobada','Eliminado') 
      AND TIPO_DOCUMENTO_ID                                                   IN (6,8)
      AND NOT EXISTS (SELECT  IDC.CARACTERISTICA_ID 
                      FROM DB_COMERCIAL.ADMI_CARACTERISTICA DBAC,
                        DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC
                      WHERE DBAC.DESCRIPCION_CARACTERISTICA = 'PROCESO_DIFERIDO'
                      AND IDC.DOCUMENTO_ID                  = DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO
                      AND IDC.CARACTERISTICA_ID             = DBAC.ID_CARACTERISTICA
                      AND IDC.VALOR                         = 'S')
      UNION ALL
      SELECT DB_FINANCIERO.INFO_PAGO_CAB.PUNTO_ID,
        ROUND(DB_FINANCIERO.INFO_PAGO_DET.VALOR_PAGO,2)*-1 AS VALOR_PAGO
      FROM DB_FINANCIERO.INFO_PAGO_CAB,
        DB_FINANCIERO.INFO_PAGO_DET
      WHERE DB_FINANCIERO.INFO_PAGO_CAB.estado_pago NOT IN ('Inactivo', 'Anulado','Asignado')
      AND DB_FINANCIERO.INFO_PAGO_CAB.id_pago       = DB_FINANCIERO.INFO_PAGO_DET.PAGO_ID
      AND NOT EXISTS(
       
                      SELECT DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO                        
                      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB
                      WHERE DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT NOT IN ('Inactivo', 'Anulado','Anulada',
                                                                                                      'Rechazada','Rechazado','Pendiente',
                                                                                                      'Aprobada','Eliminado','ErrorGasto',
                                                                                                      'ErrorDescuento','ErrorDuplicidad') 
                      AND TIPO_DOCUMENTO_ID                                                   NOT IN (6,8)
                      AND DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO            = DB_FINANCIERO.INFO_PAGO_DET.REFERENCIA_ID
                      AND EXISTS (SELECT  IDC.CARACTERISTICA_ID 
                                      FROM DB_COMERCIAL.ADMI_CARACTERISTICA DBAC,
                                        DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC
                                      WHERE DBAC.DESCRIPCION_CARACTERISTICA = 'PROCESO_DIFERIDO'
                                      AND IDC.DOCUMENTO_ID                  = DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO
                                      AND IDC.CARACTERISTICA_ID             = DBAC.ID_CARACTERISTICA
                                      AND IDC.VALOR                         = 'S')
       
                      )    
      AND NOT EXISTS(SELECT ANTO.ID_PAGO
                     FROM DB_FINANCIERO.INFO_PAGO_CAB ANTO
                     WHERE DB_FINANCIERO.INFO_PAGO_CAB.ANTICIPO_ID     = ANTO.ID_PAGO 
                     AND ANTO.ESTADO_PAGO                              = 'Cerrado'
                     AND DB_FINANCIERO.INFO_PAGO_CAB.TIPO_DOCUMENTO_ID = 10)) ESTADO_CUENTA
GROUP BY ESTADO_CUENTA.PUNTO_ID;