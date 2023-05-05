CREATE  FORCE VIEW "NAF47_TNET"."ARFAFL" ("NO_CIA", "CENTROD", "TIPO_DOC", "PERIODO", "RUTA", "NO_FACTU", "NO_LINEA", "BODEGA", "CLASE", "CATEGORIA", "NO_ARTI", "PEDIDO", "PORC_DESC", "COSTO", "PRECIO", "DESCUENTO", "TOTAL", "I_VEN", "I_VEN_N", "TIPO_PRECIO", "UN_DEVOL", "ARTI_OFE", "CANT_OFE", "COSTO_OFE", "PRECIO_OFE", "PROT_OFE", "TIPO_OFERTA", "NO_LINEA_D", "IMP_INCLUIDO", "IMP_ESPECIAL", "COSTO2", "LINEA_ART_PROMOCION", "MARGEN_VALOR_FL", "MARGEN_MINIMO", "MARGEN_OBJETIVO", "MARGEN_PORC_FL", "SECUENCIA_POLITICA", "LINEA_POLITICA", "DIVISION", "SUBDIVISION", "TSTAMP", "VALOR_COMISION_TARJETA", "VALOR_RETENCION_TARJETA", "COMISION") AS 
  SELECT "NO_CIA",
           "CENTROD",
           "TIPO_DOC",
           "PERIODO",
           "RUTA",
           "NO_FACTU",
           "NO_LINEA",
           "BODEGA",
           "CLASE",
           "CATEGORIA",
           "NO_ARTI",
           "PEDIDO",
           "PORC_DESC",
           "COSTO",
           "PRECIO",
           "DESCUENTO",
           "TOTAL",
           "I_VEN",
           "I_VEN_N",
           "TIPO_PRECIO",
           "UN_DEVOL",
           "ARTI_OFE",
           "CANT_OFE",
           "COSTO_OFE",
           "PRECIO_OFE",
           "PROT_OFE",
           "TIPO_OFERTA",
           "NO_LINEA_D",
           "IMP_INCLUIDO",
           "IMP_ESPECIAL",
           "COSTO2",
           "LINEA_ART_PROMOCION",
           "MARGEN_VALOR_FL",
           "MARGEN_MINIMO",
           "MARGEN_OBJETIVO",
           "MARGEN_PORC_FL",
           "SECUENCIA_POLITICA",
           "LINEA_POLITICA",
           "DIVISION",
           "SUBDIVISION",
           "TSTAMP",
           "VALOR_COMISION_TARJETA",
           "VALOR_RETENCION_TARJETA",
           "COMISION"
      FROM NAF47_TNET.ARFAFL@GPOETNET;