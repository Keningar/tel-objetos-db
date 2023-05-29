CREATE    OR REPLACE VIEW "NAF47_TNET"."V_FACTURACION" ("EMPRESA_ID", "TIPO", "NOMBRE_TIPO_DOCUMENTO", "ID_DOCUMENTO", "FE_EMISION", "OFICINA_ID", "NOMBRE_OFICINA", "NUMERO_FACTURA_SRI", "NUMERO_AUTORIZACION", "ESTADO", "CONTABILIZADO", "VALOR_TOTAL", "MIGRADO") AS 
  SELECT IOG.EMPRESA_ID,
       ATDF.CODIGO_TIPO_DOCUMENTO TIPO,
       ATDF.NOMBRE_TIPO_DOCUMENTO,
       IDFC.ID_DOCUMENTO,
       IDFC.FE_EMISION,
       IDFC.OFICINA_ID,
       IOG.NOMBRE_OFICINA,
       IDFC.NUMERO_FACTURA_SRI,
       IDFC.NUMERO_AUTORIZACION,
       IDFC.ESTADO_IMPRESION_FACT ESTADO,
       IDFC.CONTABILIZADO,
       IDFC.VALOR_TOTAL,
       (SELECT LISTAGG('[ '||AE.COD_DIARIO||' - '|| MDA.MIGRACION_ID||' - '||TO_CHAR(AE.FECHA,'DD/MM/YYYY')||' ]',CHR(10))
        WITHIN GROUP (ORDER BY MDA.DOCUMENTO_ORIGEN_ID)
        FROM NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO MDA,
             NAF47_TNET.MIGRA_ARCGAE AE
        WHERE MDA.DOCUMENTO_ORIGEN_ID = IDFC.ID_DOCUMENTO
        AND MDA.TIPO_MIGRACION = 'CG'
        AND AE.COD_DIARIO IN ('M_F_1','M_F_2','M_NC1','M_NC2')
        AND MDA.MIGRACION_ID = AE.ID_MIGRACION
        AND MDA.NO_CIA = AE.NO_CIA) MIGRADO
FROM DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF,
     DB_COMERCIAL.INFO_OFICINA_GRUPO IOG,
     DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
WHERE IDFC.ESTADO_IMPRESION_FACT NOT IN ('Eliminado','Rechazado','Pendiente')
AND EXISTS (SELECT NULL
            FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                 DB_GENERAL.ADMI_PARAMETRO_DET APD
            WHERE APD.VALOR2 = ATDF.CODIGO_TIPO_DOCUMENTO
            AND APC.NOMBRE_PARAMETRO = 'PROCESOS_CONTABLES'
            AND APC.ESTADO = 'Activo'
            AND APD.DESCRIPCION = 'CODIGO_DOCUMENTOS'
            AND APD.ESTADO = 'Activo'
            AND APD.PARAMETRO_ID = APC.ID_PARAMETRO)
AND IDFC.TIPO_DOCUMENTO_ID = ATDF.ID_TIPO_DOCUMENTO
AND IDFC.OFICINA_ID = IOG.ID_OFICINA;