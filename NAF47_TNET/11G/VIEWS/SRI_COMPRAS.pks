CREATE  FORCE VIEW "NAF47_TNET"."SRI_COMPRAS" ("CODIGO_SUST_TRIB", "TRANS_DERECHO_DEV_IVA", "TIPO_IDENT_PROV", "IDENT_PROVEEDOR", "CODIGO_TIPO_COMP", "FECHA_REG_CONTABLE", "NO_SERIE_ESTABLEC", "NO_SERIE_PTO_EMISION", "NO_SECUENCIAL", "FECHA_EMISION_COMP_VTA", "AUTORIZACION_COMP_VTA", "FECHA_CADUCIDAD", "BASE_IMPONIBLE_TARIFA_0", "BASE_IMPONIBLE_GRAVADO_0", "CODIGO_PORCENTAJE_IVA", "MONTO_IVA", "BASE_IMP_ICE", "COD_PORC_ICE", "MONTO_ICE", "MONTO_IVA_BIENES", "PORC_RET_IVA_BIENES", "MONTO_RET_IVA_BIENES", "MONTO_IVA_SERVICIOS", "CODIGO_PORC_RET_IVA_SERV", "MONTO_RET_IVA_SERV", "RET_FUENTE", "BASE_IMPONIBLE_RENTA", "CODIGO_PORC_RET_RENTA", "MONTO_RETENCION_RENTA", "SERIE_COMP_RET_ESTABLECIMIENTO", "SERIE_COMP_RET_PTO_EMISION", "SEC_COMP_RET", "AUTORIZACION_COMP_RET", "FECHA_EMISION_COMP_RET", "TIPO_COMP_MOD_ND_NC", "FECHA_EMISION_COMP_MODIFICADO", "SERIE_COMP_MODIFICADO_ESTAB", "SERIE_COMP_MODIFIC_PTO_EMISION", "NO_SECUENCIAL_COMP_MODIFICADO", "AUTORIZACION_COMP_MODIFICADO", "CONTRATO_CONTRATACION", "MONTO_TRANSACCION_TIT_ONEROSO", "MONTO_TRANSACCION_TIT_GRATUITO", "NO_CIA", "NO_DOCU", "TARJETA_CORP", "TIPO_DOC", "MONTO_IVA_BIENES_SERV", "ID_PORC_RET_IVA_BIENES_SERV", "MONTO_RET_IVA_BIENES_SERV", "BASE_IMPONIBLE_NO_OBJETO_IVA", "BASE_IMPONIBLE_EXCENTO_IVA", "PROV_PARTE_RELACIONADA", "COMP_REEMBOLSO", "REGISTRA_REEMBOLSO", "TIPO_PROVE_EXTRANJERO", "NOMBRE_PROV_EXTRANJERO", "MONTO_RET_IVA_BIEN_10", "MONTO_RET_IVA_BIEN_30", "MONTO_RET_IVA_SERV_20", "MONTO_RET_IVA_SERV_70", "MONTO_RET_IVA_SERV_100", "TOTAL_REEMBOLSO", "PAGO_LOCAL_EXTERIOR", "TIPO_REGIMEN_EXTERIOR", "PAIS_PAGO_PARAISO_FISAL", "PAIS_PAGO_REGIMEN_GENERAL", "DENOMINACION", "PAIS_EFECTUA_PAGO", "CONVENIO_DOBLE_TRIBUTACION", "SUJETO_A_RETENCION") AS 
  SELECT "CODIGO_SUST_TRIB",
           "TRANS_DERECHO_DEV_IVA",
           "TIPO_IDENT_PROV",
           "IDENT_PROVEEDOR",
           "CODIGO_TIPO_COMP",
           "FECHA_REG_CONTABLE",
           "NO_SERIE_ESTABLEC",
           "NO_SERIE_PTO_EMISION",
           "NO_SECUENCIAL",
           "FECHA_EMISION_COMP_VTA",
           "AUTORIZACION_COMP_VTA",
           "FECHA_CADUCIDAD",
           "BASE_IMPONIBLE_TARIFA_0",
           "BASE_IMPONIBLE_GRAVADO_0",
           "CODIGO_PORCENTAJE_IVA",
           "MONTO_IVA",
           "BASE_IMP_ICE",
           "COD_PORC_ICE",
           "MONTO_ICE",
           "MONTO_IVA_BIENES",
           "PORC_RET_IVA_BIENES",
           "MONTO_RET_IVA_BIENES",
           "MONTO_IVA_SERVICIOS",
           "CODIGO_PORC_RET_IVA_SERV",
           "MONTO_RET_IVA_SERV",
           "RET_FUENTE",
           "BASE_IMPONIBLE_RENTA",
           "CODIGO_PORC_RET_RENTA",
           "MONTO_RETENCION_RENTA",
           "SERIE_COMP_RET_ESTABLECIMIENTO",
           "SERIE_COMP_RET_PTO_EMISION",
           "SEC_COMP_RET",
           "AUTORIZACION_COMP_RET",
           "FECHA_EMISION_COMP_RET",
           "TIPO_COMP_MOD_ND_NC",
           "FECHA_EMISION_COMP_MODIFICADO",
           "SERIE_COMP_MODIFICADO_ESTAB",
           "SERIE_COMP_MODIFIC_PTO_EMISION",
           "NO_SECUENCIAL_COMP_MODIFICADO",
           "AUTORIZACION_COMP_MODIFICADO",
           "CONTRATO_CONTRATACION",
           "MONTO_TRANSACCION_TIT_ONEROSO",
           "MONTO_TRANSACCION_TIT_GRATUITO",
           "NO_CIA",
           "NO_DOCU",
           "TARJETA_CORP",
           "TIPO_DOC",
           "MONTO_IVA_BIENES_SERV",
           "ID_PORC_RET_IVA_BIENES_SERV",
           "MONTO_RET_IVA_BIENES_SERV",
           "BASE_IMPONIBLE_NO_OBJETO_IVA",
           "BASE_IMPONIBLE_EXCENTO_IVA",
           "PROV_PARTE_RELACIONADA",
           "COMP_REEMBOLSO",
           "REGISTRA_REEMBOLSO",
           "TIPO_PROVE_EXTRANJERO",
           "NOMBRE_PROV_EXTRANJERO",
           "MONTO_RET_IVA_BIEN_10",
           "MONTO_RET_IVA_BIEN_30",
           "MONTO_RET_IVA_SERV_20",
           "MONTO_RET_IVA_SERV_70",
           "MONTO_RET_IVA_SERV_100",
           "TOTAL_REEMBOLSO",
           "PAGO_LOCAL_EXTERIOR",
           "TIPO_REGIMEN_EXTERIOR",
           "PAIS_PAGO_PARAISO_FISAL",
           "PAIS_PAGO_REGIMEN_GENERAL",
           "DENOMINACION",
           "PAIS_EFECTUA_PAGO",
           "CONVENIO_DOBLE_TRIBUTACION",
           "SUJETO_A_RETENCION"
      FROM NAF47_TNET.SRI_COMPRAS@GPOETNET;