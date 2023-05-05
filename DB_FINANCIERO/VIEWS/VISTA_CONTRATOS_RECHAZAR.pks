CREATE FORCE EDITIONABLE VIEW "DB_FINANCIERO"."VISTA_CONTRATOS_RECHAZAR" ("ID_CONTRATO", "PERSONA_EMPRESA_ROL_ID", "RECHAZAR") AS 
  SELECT ic.ID_CONTRATO, 
       ic.PERSONA_EMPRESA_ROL_ID,
       CASE 
         WHEN CAST(SYSDATE AS TIMESTAMP WITH LOCAL TIME ZONE) > CAST(TO_DATE(TRIM(SUBSTR(TRIM(idc.VALOR), 1, 10)), 'DD-MM-YYYY') AS TIMESTAMP WITH
                                                                     LOCAL TIME ZONE)
         THEN 'S' 
         ELSE 'N'
       END as RECHAZAR
FROM DB_COMERCIAL.INFO_CONTRATO ic
JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper
ON iper.ID_PERSONA_ROL = ic.PERSONA_EMPRESA_ROL_ID
JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ier
ON ier.ID_EMPRESA_ROL = iper.EMPRESA_ROL_ID
JOIN DB_COMERCIAL.INFO_PUNTO ip
ON ip.PERSONA_EMPRESA_ROL_ID = iper.ID_PERSONA_ROL
JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB idfc
ON idfc.PUNTO_ID = ip.ID_PUNTO
JOIN DB_FINANCIERO.Info_Documento_Caracteristica idc
ON idfc.Id_Documento = idc.Documento_Id
JOIN DB_COMERCIAL.Admi_Caracteristica ac
ON ac.Id_Caracteristica = idc.Caracteristica_Id
WHERE ic.ESTADO = 'Pendiente'
  AND ic.ORIGEN = 'MOVIL'
  AND ac.Descripcion_Caracteristica = 'FECHA_VIGENCIA'
  AND idc.Estado = 'Activo'
  AND idfc.ESTADO_IMPRESION_FACT IN ('Pendiente', 'Activo')
  AND idfc.ID_DOCUMENTO IN (
                              SELECT idfc2.iD_DOCUMENTO 
                              FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB idfc2
                              JOIN DB_FINANCIERO.Info_Documento_Caracteristica idc2
                              ON idfc2.Id_Documento = idc2.Documento_Id
                              JOIN DB_COMERCIAL.Admi_Caracteristica ac2
                              ON ac2.Id_Caracteristica = idc2.Caracteristica_Id
                              WHERE ac2.Descripcion_Caracteristica = 'POR_CONTRATO_DIGITAL'
                                AND idc2.Valor = 'S'
                                AND idc2.Estado = 'Activo'
                           )
GROUP BY ic.ID_CONTRATO, ic.PERSONA_EMPRESA_ROL_ID, idc.VALOR;