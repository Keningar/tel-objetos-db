CREATE  FORCE VIEW "NAF47_TNET"."V_DOCUMENTOS_INV_FAC" ("MODULO", "TDOC", "CODIGO", "TRANS", "FECHA", "OR_DE", "VALOR_BRUTO", "DESCUENTO", "SUB_TOTAL", "IMPUESTO", "VALOR_NETO", "ANULADA", "BOD_ORIG", "BOD_DEST", "RESPON_STAND", "NO_PROVE", "NO_CIA", "CENTRO", "PROCESADO", "NO_REFE", "ORIGEN", "LISTADA", "GRUPO", "BODEGA_S", "USUARIO_T") AS 
  SELECT "MODULO",
           "TDOC",
           "CODIGO",
           "TRANS",
           "FECHA",
           "OR_DE",
           "VALOR_BRUTO",
           "DESCUENTO",
           "SUB_TOTAL",
           "IMPUESTO",
           "VALOR_NETO",
           "ANULADA",
           "BOD_ORIG",
           "BOD_DEST",
           "RESPON_STAND",
           "NO_PROVE",
           "NO_CIA",
           "CENTRO",
           "PROCESADO",
           "NO_REFE",
           "ORIGEN",
           "LISTADA",
           "GRUPO",
           "BODEGA_S",
           "USUARIO_T"
      FROM NAF47_TNET.V_DOCUMENTOS_INV_FAC@GPOETNET;