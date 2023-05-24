CREATE OR REPLACE VIEW "NAF47_TNET"."CP_V_COMPROBANTES_ELECTRONICOS" ("NO_COMPANIA", "NO_PROVEEDOR", "RAZON_SOCIAL", "TIPO_DOCUMENTO", "NO_DOCUMENTO", "COMPROBANTE_VENTA", "FECHA_DOCUMENTO", "GRAVADO", "EXCENTOS", "SUBTOTAL", "IMPUESTOS", "TOTAL", "RETENCIONES", "POR_PAGAR", "ESTADO", "DESC_ESTADO", "TIPO_RETENCION", "XML_GENERADO", "COMPROBANTE_RETENCION", "FECHA_RETENCION", "DETALLE_RECHAZO", "NOMBRE_ARCHIVO", "RUTA_ARCHIVO", "IND_REGION", "TOT_RET") AS 
  SELECT "NO_COMPANIA",
           "NO_PROVEEDOR",
           "RAZON_SOCIAL",
           "TIPO_DOCUMENTO",
           "NO_DOCUMENTO",
           "COMPROBANTE_VENTA",
           "FECHA_DOCUMENTO",
           "GRAVADO",
           "EXCENTOS",
           "SUBTOTAL",
           "IMPUESTOS",
           "TOTAL",
           "RETENCIONES",
           "POR_PAGAR",
           "ESTADO",
           "DESC_ESTADO",
           "TIPO_RETENCION",
           "XML_GENERADO",
           "COMPROBANTE_RETENCION",
           "FECHA_RETENCION",
           "DETALLE_RECHAZO",
           "NOMBRE_ARCHIVO",
           "RUTA_ARCHIVO",
           "IND_REGION",
           "TOT_RET"
      FROM NAF47_TNET.CP_V_COMPROBANTES_ELECTRONICOS@GPOETNET;