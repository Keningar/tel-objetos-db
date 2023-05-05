CREATE  FORCE VIEW "NAF47_TNET"."MIGRA_ARINME" ("NO_CIA", "CENTRO", "TIPO_DOC", "PERIODO", "RUTA", "NO_DOCU", "ESTADO", "FECHA", "NO_FISICO", "SERIE_FISICO", "CONDUCE", "OBSERV1", "IMP_VENTAS", "IMP_INCLUIDO", "IMP_ESPECIAL", "NO_PROVE", "TIPO_REFE", "NO_REFE", "SERIE_REFE", "NO_DOCU_REFE", "DESCUENTO", "MOV_TOT", "TOT_ART_IV", "MONEDA_REFE_CXP", "TIPO_CAMBIO", "MONTO_DIGITADO_COMPRA", "MONTO_BIENES", "MONTO_IMPORTAC", "MONTO_SERV", "ORIGEN", "TIPO_DOC_D", "N_DOCU_D", "FECHA_ENT", "HORA_ENT", "IND_COMPLETA", "ORDEN_COMPRA", "FEC_EMISION_DESPACHO", "FEC_LLEGADA_DESPACHO", "TRANSPORTE", "NOTA_CREDITO", "VALOR_NCREDITO", "ART_ROTOS", "COMENTARIOS", "NO_PEDIDO_COBOL", "BODEGA_LOCAL", "IND_TRANSFERIDO", "RESPON_STAND", "USUARIO", "IMPUESTO", "DESCUENTO_C", "NUMERO_SOLICITUD", "FECHA_APLICACION", "EMPLE_SOLIC", "C_COSTO_EMPLESOL", "NO_CLIENTE", "VENDEDOR", "APLICA_GUIA_REM", "RECLAMO_PROVEEDOR", "MOV_TOT2") AS 
  SELECT "NO_CIA",
           "CENTRO",
           "TIPO_DOC",
           "PERIODO",
           "RUTA",
           "NO_DOCU",
           "ESTADO",
           "FECHA",
           "NO_FISICO",
           "SERIE_FISICO",
           "CONDUCE",
           "OBSERV1",
           "IMP_VENTAS",
           "IMP_INCLUIDO",
           "IMP_ESPECIAL",
           "NO_PROVE",
           "TIPO_REFE",
           "NO_REFE",
           "SERIE_REFE",
           "NO_DOCU_REFE",
           "DESCUENTO",
           "MOV_TOT",
           "TOT_ART_IV",
           "MONEDA_REFE_CXP",
           "TIPO_CAMBIO",
           "MONTO_DIGITADO_COMPRA",
           "MONTO_BIENES",
           "MONTO_IMPORTAC",
           "MONTO_SERV",
           "ORIGEN",
           "TIPO_DOC_D",
           "N_DOCU_D",
           "FECHA_ENT",
           "HORA_ENT",
           "IND_COMPLETA",
           "ORDEN_COMPRA",
           "FEC_EMISION_DESPACHO",
           "FEC_LLEGADA_DESPACHO",
           "TRANSPORTE",
           "NOTA_CREDITO",
           "VALOR_NCREDITO",
           "ART_ROTOS",
           "COMENTARIOS",
           "NO_PEDIDO_COBOL",
           "BODEGA_LOCAL",
           "IND_TRANSFERIDO",
           "RESPON_STAND",
           "USUARIO",
           "IMPUESTO",
           "DESCUENTO_C",
           "NUMERO_SOLICITUD",
           "FECHA_APLICACION",
           "EMPLE_SOLIC",
           "C_COSTO_EMPLESOL",
           "NO_CLIENTE",
           "VENDEDOR",
           "APLICA_GUIA_REM",
           "RECLAMO_PROVEEDOR",
           "MOV_TOT2"
      FROM NAF47_TNET.MIGRA_ARINME@GPOETNET;